import 'package:flutter/material.dart';
import '../modelos/evento.dart';

class NuevoEvento extends StatefulWidget {
  @override
  _NuevoEventoState createState() => _NuevoEventoState();
}

class _NuevoEventoState extends State<NuevoEvento> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _ubicacionController = TextEditingController();
  final _imagenController = TextEditingController();
  
  DateTime _fechaSeleccionada = DateTime.now();
  TimeOfDay _horaSeleccionada = TimeOfDay.now();
  TipoEvento _tipoSeleccionado = TipoEvento.CONCIERTO;

  Future<void> _seleccionarFecha(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fechaSeleccionada,
      firstDate: DateTime.now(),
      lastDate: DateTime(2025, 12, 31),
    );
    if (picked != null && picked != _fechaSeleccionada) {
      setState(() {
        _fechaSeleccionada = picked;
      });
    }
  }

  Future<void> _seleccionarHora(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _horaSeleccionada,
    );
    if (picked != null && picked != _horaSeleccionada) {
      setState(() {
        _horaSeleccionada = picked;
      });
    }
  }

  void _guardarEvento() {
    if (_formKey.currentState!.validate()) {
      // Combinar fecha y hora
      final fechaCompleta = DateTime(
        _fechaSeleccionada.year,
        _fechaSeleccionada.month,
        _fechaSeleccionada.day,
        _horaSeleccionada.hour,
        _horaSeleccionada.minute,
      );

      // Crear nuevo evento (aquí normalmente guardarías en una base de datos)
      final nuevoEvento = Evento(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        titulo: _tituloController.text,
        descripcion: _descripcionController.text,
        fecha: fechaCompleta,
        ubicacion: _ubicacionController.text,
        tipo: _tipoSeleccionado,
        imagenUrl: _imagenController.text.isEmpty 
            ? 'https://picsum.photos/300/200?random=${DateTime.now().millisecondsSinceEpoch}'
            : _imagenController.text,
      );

      // Retornar el evento a la pantalla anterior
      Navigator.pop(context, nuevoEvento);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Nuevo Evento'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _guardarEvento,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Título
              TextFormField(
                controller: _tituloController,
                decoration: InputDecoration(
                  labelText: 'Título del evento',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un título';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Descripción
              TextFormField(
                controller: _descripcionController,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa una descripción';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Tipo de evento
              DropdownButtonFormField<TipoEvento>(
                value: _tipoSeleccionado,
                decoration: InputDecoration(
                  labelText: 'Tipo de evento',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                items: [
                  DropdownMenuItem(
                    value: TipoEvento.CONCIERTO,
                    child: Text('Concierto'),
                  ),
                  DropdownMenuItem(
                    value: TipoEvento.FERIA,
                    child: Text('Feria'),
                  ),
                  DropdownMenuItem(
                    value: TipoEvento.CONFERENCIA,
                    child: Text('Conferencia'),
                  ),
                ],
                onChanged: (TipoEvento? value) {
                  setState(() {
                    _tipoSeleccionado = value!;
                  });
                },
              ),
              SizedBox(height: 16),

              // Fecha y Hora
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _seleccionarFecha(context),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Fecha',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Text(
                          '${_fechaSeleccionada.day}/${_fechaSeleccionada.month}/${_fechaSeleccionada.year}',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: () => _seleccionarHora(context),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Hora',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.access_time),
                        ),
                        child: Text(
                          _horaSeleccionada.format(context),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Ubicación
              TextFormField(
                controller: _ubicacionController,
                decoration: InputDecoration(
                  labelText: 'Ubicación',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa una ubicación';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // URL de imagen (opcional)
              TextFormField(
                controller: _imagenController,
                decoration: InputDecoration(
                  labelText: 'URL de imagen (opcional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.image),
                ),
              ),
              SizedBox(height: 24),

              // Botón guardar
              ElevatedButton(
                onPressed: _guardarEvento,
                child: Text('Guardar Evento'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    _ubicacionController.dispose();
    _imagenController.dispose();
    super.dispose();
  }
}