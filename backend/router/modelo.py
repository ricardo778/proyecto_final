# router/modelo.py
from sqlalchemy import create_engine, Column, Integer, String, DateTime
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from datetime import datetime

# ✅ CONFIGURACIÓN DE LA BASE DE DATOS
SQLALCHEMY_DATABASE_URL = "sqlite:///./eventagenda.db"

# ✅ CREAR ENGINE
engine = create_engine(
    SQLALCHEMY_DATABASE_URL, 
    connect_args={"check_same_thread": False}
)

# ✅ CREAR SESSION Y BASE
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

# ✅ MODELO DE USUARIO
class Usuario(Base):
    __tablename__ = "usuarios"
    
    id = Column(Integer, primary_key=True, index=True)
    nombre = Column(String, nullable=False)
    email = Column(String, unique=True, nullable=False)
    password_hash = Column(String, nullable=False)
    telefono = Column(String, nullable=True)
    fecha_creacion = Column(DateTime, default=datetime.utcnow)
    
    def to_dict(self):
        return {
            "id": self.id,
            "nombre": self.nombre,
            "email": self.email,
            "telefono": self.telefono,
            "fecha_creacion": self.fecha_creacion.isoformat()
        }

# ✅ FUNCIÓN PARA CREAR TABLAS - CORREGIDA
def crear_tablas():
    Base.metadata.create_all(bind=engine)  # ✅ usa 'engine' no 'conexion.engine'
    print("✅ Tablas creadas exitosamente")

# ✅ FUNCIÓN PARA OBTENER LA SESIÓN DE BD
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()