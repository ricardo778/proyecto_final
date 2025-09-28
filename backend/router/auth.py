# router/auth.py
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
import bcrypt
import jwt
from datetime import datetime, timedelta
from pydantic import BaseModel
from typing import Optional

# ✅ IMPORTAR DESDE MODELO - CORREGIDO
from router.modelo import Usuario, get_db

router = APIRouter(prefix="/auth", tags=["auth"])

# Configuración
JWT_SECRET = "clave-secreta-eventagenda-2024"
ALGORITHM = "HS256"

# Modelos Pydantic
class RegistroRequest(BaseModel):
    nombre: str
    email: str
    password: str
    telefono: Optional[str] = None

class LoginRequest(BaseModel):
    email: str
    password: str

class UsuarioResponse(BaseModel):
    id: int
    nombre: str
    email: str
    telefono: Optional[str]

class LoginResponse(BaseModel):
    token: str
    usuario: UsuarioResponse

# Funciones de utilidad
def hash_password(password: str) -> str:
    salt = bcrypt.gensalt()
    return bcrypt.hashpw(password.encode('utf-8'), salt).decode('utf-8')

def verify_password(plain_password: str, hashed_password: str) -> bool:
    return bcrypt.checkpw(plain_password.encode('utf-8'), hashed_password.encode('utf-8'))

def crear_token(usuario_id: int, email: str):
    payload = {
        "usuario_id": usuario_id,
        "email": email,
        "exp": datetime.utcnow() + timedelta(days=30)
    }
    return jwt.encode(payload, JWT_SECRET, algorithm=ALGORITHM)

# Endpoints
@router.post("/registro", response_model=LoginResponse)  # ✅ CAMBIADO A LoginResponse
def registrar_usuario(usuario_data: RegistroRequest, db: Session = Depends(get_db)):
    # Verificar si el email ya existe
    usuario_existente = db.query(Usuario).filter(Usuario.email == usuario_data.email).first()
    if usuario_existente:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="El email ya está registrado"
        )
    
    # Crear nuevo usuario
    password_hash = hash_password(usuario_data.password)
    nuevo_usuario = Usuario(
        nombre=usuario_data.nombre,
        email=usuario_data.email,
        password_hash=password_hash,
        telefono=usuario_data.telefono
    )
    
    db.add(nuevo_usuario)
    db.commit()
    db.refresh(nuevo_usuario)
    
    # ✅ GENERAR TOKEN AUTOMÁTICAMENTE después del registro
    token = crear_token(nuevo_usuario.id, nuevo_usuario.email)
    
    return LoginResponse(
        token=token,
        usuario=UsuarioResponse(
            id=nuevo_usuario.id,
            nombre=nuevo_usuario.nombre,
            email=nuevo_usuario.email,
            telefono=nuevo_usuario.telefono
        )
    )

@router.post("/login", response_model=LoginResponse)
def login(login_data: LoginRequest, db: Session = Depends(get_db)):
    # Buscar usuario por email
    usuario = db.query(Usuario).filter(Usuario.email == login_data.email).first()
    
    if not usuario or not verify_password(login_data.password, usuario.password_hash):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Email o contraseña incorrectos"
        )
    
    # Generar token JWT
    token = crear_token(usuario.id, usuario.email)
    
    return LoginResponse(
        token=token,
        usuario=UsuarioResponse(
            id=usuario.id,
            nombre=usuario.nombre,
            email=usuario.email,
            telefono=usuario.telefono
        )
    )

@router.get("/verificar")
def verificar_token(token: str, db: Session = Depends(get_db)):
    try:
        payload = jwt.decode(token, JWT_SECRET, algorithms=[ALGORITHM])
        usuario_id = payload.get("usuario_id")
        
        usuario = db.query(Usuario).filter(Usuario.id == usuario_id).first()
        if not usuario:
            raise HTTPException(status_code=401, detail="Usuario no encontrado")
            
        return UsuarioResponse(
            id=usuario.id,
            nombre=usuario.nombre,
            email=usuario.email,
            telefono=usuario.telefono
        )
        
    except jwt.ExpiredSignatureError:
        raise HTTPException(status_code=401, detail="Token expirado")
    except jwt.InvalidTokenError:
        raise HTTPException(status_code=401, detail="Token inválido")