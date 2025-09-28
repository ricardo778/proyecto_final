import os
import requests
from fastapi import FastAPI, HTTPException, Depends
from pydantic import BaseModel
from typing import List, Optional, Dict, Any
from fastapi.middleware.cors import CORSMiddleware
from router.modelo import crear_tablas
from router import auth
EVENTYAY_API_URL = "https://api.eventyay.com/v1/events"

app = FastAPI(
    title="API de Eventos y Autenticación",
    description="API para eventos de Eventyay + sistema de autenticación",
)

# ✅ CONFIGURAR CORS (ya lo tienes)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Permitir TODOS los orígenes
    allow_credentials=True,
    allow_methods=["*"],  # Permitir TODOS los métodos
    allow_headers=["*"],  # Permitir TODOS los headers
)

# ✅ CREAR TABLAS AL INICIAR
@app.on_event("startup")
def on_startup():
    crear_tablas()
    print("✅ Base de datos de autenticación inicializada")

# ✅ INCLUIR ROUTER DE AUTENTICACIÓN
app.include_router(auth.router)

# ✅ TUS MODELOS ORIGINALES DE EVENTOS
class Ubicacion(BaseModel):
    """Modelo para la ubicación del evento."""
    nombre_lugar: Optional[str] = "No especificado"
    ciudad: Optional[str] = "No especificado"
    pais: Optional[str] = "No especificado"

class EventoDetalle(BaseModel):
    """Modelo para los detalles simplificados del evento."""
    nombre: str
    tipo: str
    fecha: Optional[str]
    hora: Optional[str]
    ubicacion: Ubicacion
    descripcion_corta: Optional[str] 

# ✅ TU FUNCIÓN ORIGINAL DE MAPEO
def _mapear_evento_eventyay(raw_event: Dict[str, Any]) -> EventoDetalle:
    """Mapea la respuesta de Eventyay (JSON:API format) a nuestro modelo simple."""
    
    attributes = raw_event.get('attributes', {})
    
    # 1. Nombre y Tipo
    nombre = attributes.get('name', 'Evento sin nombre')
    # Usaremos el 'state' o 'event-type' como tipo para fines de ejemplo
    tipo = attributes.get('event-type', 'General') 

    # 2. Fecha y Hora
    # Eventyay usa 'starts-at' en formato ISO (ej: 2024-03-01T10:00:00Z)
    starts_at_iso = attributes.get('starts-at', '')
    
    # Extraer la fecha (YYYY-MM-DD)
    fecha = starts_at_iso.split('T')[0] if starts_at_iso else 'Fecha no disponible'
    
    # Extraer la hora (HH:MM:SS), quitando la 'Z' de UTC
    hora_iso = starts_at_iso.split('T')[1].replace('Z', '') if len(starts_at_iso.split('T')) > 1 else 'Hora no disponible'
    
    # 3. Ubicación
    ubicacion_details = attributes.get('location-name')
    
    ubicacion = Ubicacion(
        nombre_lugar=ubicacion_details or 'Lugar no listado',
        ciudad='No disponible', 
        pais='No disponible',
    )

    # 4. Descripción corta
    descripcion_corta = attributes.get('short-description')

    return EventoDetalle(
        nombre=nombre,
        tipo=tipo,
        fecha=fecha,
        hora=hora_iso,
        ubicacion=ubicacion,
        descripcion_corta=descripcion_corta,
    )

# ✅ TU ENDPOINT ORIGINAL DE EVENTOS
@app.get("/api/v1/eventos", response_model=List[EventoDetalle])
async def obtener_eventos(search_query: Optional[str] = None):
    """
    Consume la API de Eventyay para obtener eventos, filtrando los campos.
    :param search_query: Término de búsqueda (ej: "hackathon", "robotica").
    """
    
    # 1. Parámetros de la petición a Eventyay
    params = {
        'page[size]': 20, # Limitar a 20 resultados
        'sort': 'starts-at',
    }
    
    # 2. Añadir el filtro de búsqueda si se proporciona
    if search_query:
        # Eventyay usa 'filter' para buscar por nombre
        params['filter[name]'] = search_query 

    try:
        # 3. Hacer la petición a la API de Eventyay
        response = requests.get(EVENTYAY_API_URL, params=params)
        response.raise_for_status() 
        
        data = response.json()
        
        # 4. Eventyay usa el formato JSON:API, la lista de eventos está en 'data'
        eventos_raw = data.get('data', [])
        
        # 5. Mapear y filtrar cada evento al modelo EventoDetalle
        eventos_limpios = [_mapear_evento_eventyay(e) for e in eventos_raw]
        
        return eventos_limpios

    except requests.exceptions.RequestException as e:
        print(f"Error al conectar con Eventyay: {e}")
        raise HTTPException(
            status_code=503,
            detail="Error al obtener datos del servicio externo (Eventyay).",
        )

# ✅ ENDPOINTS ADICIONALES PARA VERIFICAR ESTADO
@app.get("/")
def root():
    return {
        "message": "EventAgenda API funcionando", 
        "servicios": {
            "eventos": "Disponible en /api/v1/eventos",
            "autenticacion": "Disponible en /auth/registro y /auth/login"
        }
    }

@app.get("/health")
def health_check():
    return {"status": "healthy", "servicios": ["eventos", "autenticacion"]}
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000, reload=True) 