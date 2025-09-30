import 'package:flutter/material.dart';
import '../servicios/auth_service.dart';
import '../servicios/tema_service.dart';
import 'login_screen.dart';

class PerfilScreen extends StatefulWidget {
  @override
  _PerfilScreenState createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _passwordActualController = TextEditingController();
  final _nuevoPasswordController = TextEditingController();
  final _confirmarPasswordController = TextEditingController();
  
  bool _editando = false;
  bool _cargando = true;
  bool _guardando = false;
  bool _mostrarCambioPassword = false;
  bool _ocultarPasswordActual = true;
  bool _ocultarNuevoPassword = true;
  bool _ocultarConfirmarPassword = true;
  
  Map<String, dynamic>? _usuario;

  @override
  void initState() {
    super.initState();
    _cargarDatosUsuario();
  }

  void _cargarDatosUsuario() async {
    try {
      final usuario = await AuthService.obtenerUsuario();
      
      if (usuario != null) {
        setState(() {
          _usuario = usuario;
          _nombreController.text = usuario['nombre'] ?? '';
          _emailController.text = usuario['email'] ?? '';
          _telefonoController.text = usuario['telefono'] ?? '';
          _cargando = false;
        });
      } else {
        final resultado = await AuthService.verificarToken();
        if (resultado['success'] == true) {
          setState(() {
            _usuario = resultado['usuario'];
            _nombreController.text = resultado['usuario']['nombre'] ?? '';
            _emailController.text = resultado['usuario']['email'] ?? '';
            _telefonoController.text = resultado['usuario']['telefono'] ?? '';
            _cargando = false;
          });
        } else {
          setState(() {
            _cargando = false;
          });
        }
      }
    } catch (e) {
      print('❌ Error cargando datos del usuario: $e');
      setState(() {
        _cargando = false;
      });
    }
  }

  void _toggleEditar() {
    setState(() {
      _editando = !_editando;
      _mostrarCambioPassword = false;
      if (!_editando) {
        _restaurarValoresOriginales();
        _limpiarCamposPassword();
      }
    });
  }

  void _restaurarValoresOriginales() {
    if (_usuario != null) {
      _nombreController.text = _usuario!['nombre'] ?? '';
      _emailController.text = _usuario!['email'] ?? '';
      _telefonoController.text = _usuario!['telefono'] ?? '';
    }
  }

  void _limpiarCamposPassword() {
    _passwordActualController.clear();
    _nuevoPasswordController.clear();
    _confirmarPasswordController.clear();
  }

  void _toggleCambioPassword() {
    setState(() {
      _mostrarCambioPassword = !_mostrarCambioPassword;
      if (!_mostrarCambioPassword) {
        _limpiarCamposPassword();
      }
    });
  }

  void _guardarCambios() async {
    if (_nombreController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('El nombre no puede estar vacío'), backgroundColor: Colors.red),
      );
      return;
    }
    
    if (_emailController.text.trim().isEmpty || !_emailController.text.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ingresa un email válido'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() {
      _guardando = true;
    });

    try {
      final resultado = await AuthService.actualizarPerfil(
        nombre: _nombreController.text.trim(),
        email: _emailController.text.trim(),
        telefono: _telefonoController.text.trim(),
      );

      if (resultado['success'] == true) {
        setState(() {
          _usuario = resultado['usuario'];
          _editando = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(children: [Icon(Icons.check_circle, color: Colors.white), SizedBox(width: 8), Text('Perfil actualizado exitosamente')]),
            backgroundColor: TemaService.colorAcento,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(resultado['message'] ?? 'Error al actualizar el perfil'), backgroundColor: Colors.red),
        );
        _restaurarValoresOriginales();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión: $e'), backgroundColor: Colors.red),
      );
      _restaurarValoresOriginales();
    } finally {
      setState(() {
        _guardando = false;
      });
    }
  }

  void _cambiarPassword() async {
    if (_passwordActualController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ingresa tu contraseña actual'), backgroundColor: Colors.red),
      );
      return;
    }
    
    if (_nuevoPasswordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('La nueva contraseña debe tener al menos 6 caracteres'), backgroundColor: Colors.red),
      );
      return;
    }
    
    if (_nuevoPasswordController.text != _confirmarPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Las contraseñas no coinciden'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() {
      _guardando = true;
    });

    try {
      final resultado = await AuthService.cambiarPassword(
        passwordActual: _passwordActualController.text,
        nuevoPassword: _nuevoPasswordController.text,
      );

      if (resultado['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(children: [Icon(Icons.check_circle, color: Colors.white), SizedBox(width: 8), Text('Contraseña actualizada exitosamente')]),
            backgroundColor: TemaService.colorAcento,
          ),
        );
        _toggleCambioPassword();
        _limpiarCamposPassword();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(resultado['message'] ?? 'Error al cambiar la contraseña'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() {
        _guardando = false;
      });
    }
  }

  void _cancelarEdicion() {
    _restaurarValoresOriginales();
    _limpiarCamposPassword();
    setState(() {
      _editando = false;
      _mostrarCambioPassword = false;
    });
  }

  void _cerrarSesion() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(children: [Icon(Icons.logout, color: Colors.red), SizedBox(width: 8), Text('Cerrar Sesión')]),
        content: Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancelar', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              AuthService.logout();
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String titulo, String valor, IconData icono, TextEditingController controller, bool editable) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Card(
        elevation: _editando ? 3 : 1,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(color: TemaService.colorPrimario.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(icono, color: TemaService.colorPrimario, size: 20),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(titulo, style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w500)),
                    SizedBox(height: 4),
                    _editando && editable
                        ? TextFormField(
                            controller: controller,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          )
                        : Text(
                            valor.isNotEmpty ? valor : 'No especificado',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[800]),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return Scaffold(
        appBar: AppBar(title: Text('Mi Perfil'), backgroundColor: TemaService.colorPrimario, foregroundColor: Colors.white),
        body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [CircularProgressIndicator(), SizedBox(height: 20), Text('Cargando perfil...')])),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Perfil', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: TemaService.colorPrimario,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: _editando 
            ? [IconButton(icon: Icon(Icons.close), onPressed: _cancelarEdicion, tooltip: 'Cancelar')]
            : [IconButton(icon: Icon(Icons.edit), onPressed: _toggleEditar, tooltip: 'Editar')],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Sección de foto de perfil
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: Offset(0, 4))],
              ),
              child: Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: [TemaService.colorPrimario, TemaService.colorSecundario], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    ),
                    child: CircleAvatar(radius: 60, backgroundColor: Colors.transparent, child: Icon(Icons.person, size: 50, color: Colors.white)),
                  ),
                  SizedBox(height: 20),
                  Text(_nombreController.text.isNotEmpty ? _nombreController.text : 'Usuario', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey[800])),
                  SizedBox(height: 4),
                  Text(_emailController.text.isNotEmpty ? _emailController.text : 'email@ejemplo.com', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                  SizedBox(height: 20),
                  
                  // Botón editar/guardar
                  _guardando
                      ? CircularProgressIndicator()
                      : ElevatedButton.icon(
                          onPressed: () {
                            if (_editando) {
                              _guardarCambios();
                            } else {
                              _toggleEditar();
                            }
                          },
                          icon: Icon(_editando ? Icons.save : Icons.edit, size: 20),
                          label: Text(_editando ? 'Guardar Cambios' : 'Editar Perfil', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _editando ? TemaService.colorAcento : TemaService.colorPrimario,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                          ),
                        ),
                  
                  SizedBox(height: 10),
                  
                  // Botón cambiar contraseña
                  if (_editando && !_mostrarCambioPassword)
                    TextButton(
                      onPressed: _toggleCambioPassword,
                      child: Text('Cambiar Contraseña', style: TextStyle(color: TemaService.colorPrimario)),
                    ),
                ],
              ),
            ),
            
            SizedBox(height: 20),
            
            // Información personal
            if (_editando) ...[
              _buildInfoItem('Nombre', _nombreController.text, Icons.person, _nombreController, true),
              _buildInfoItem('Email', _emailController.text, Icons.email, _emailController, true),
              _buildInfoItem('Teléfono', _telefonoController.text, Icons.phone, _telefonoController, true),
            ] else ...[
              _buildInfoItem('Nombre', _nombreController.text, Icons.person, _nombreController, false),
              _buildInfoItem('Email', _emailController.text, Icons.email, _emailController, false),
              _buildInfoItem('Teléfono', _telefonoController.text, Icons.phone, _telefonoController, false),
            ],
            
            // Sección de cambio de contraseña
            if (_mostrarCambioPassword) ...[
              SizedBox(height: 20),
              Card(
                elevation: 3,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.lock, color: TemaService.colorPrimario),
                          SizedBox(width: 8),
                          Text('Cambiar Contraseña', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Spacer(),
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: _toggleCambioPassword,
                            tooltip: 'Cerrar',
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordActualController,
                        obscureText: _ocultarPasswordActual,
                        decoration: InputDecoration(
                          labelText: 'Contraseña Actual',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          suffixIcon: IconButton(
                            icon: Icon(_ocultarPasswordActual ? Icons.visibility : Icons.visibility_off),
                            onPressed: () => setState(() => _ocultarPasswordActual = !_ocultarPasswordActual),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _nuevoPasswordController,
                        obscureText: _ocultarNuevoPassword,
                        decoration: InputDecoration(
                          labelText: 'Nueva Contraseña',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          suffixIcon: IconButton(
                            icon: Icon(_ocultarNuevoPassword ? Icons.visibility : Icons.visibility_off),
                            onPressed: () => setState(() => _ocultarNuevoPassword = !_ocultarNuevoPassword),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _confirmarPasswordController,
                        obscureText: _ocultarConfirmarPassword,
                        decoration: InputDecoration(
                          labelText: 'Confirmar Nueva Contraseña',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          suffixIcon: IconButton(
                            icon: Icon(_ocultarConfirmarPassword ? Icons.visibility : Icons.visibility_off),
                            onPressed: () => setState(() => _ocultarConfirmarPassword = !_ocultarConfirmarPassword),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _cambiarPassword,
                        child: Text('Actualizar Contraseña'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TemaService.colorAcento,
                          foregroundColor: Colors.white,
                          minimumSize: Size(double.infinity, 50),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            
            SizedBox(height: 30),
            
            // Botón cerrar sesión
            if (!_editando)
              ElevatedButton(
                onPressed: _cerrarSesion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text('Cerrar Sesión'),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _telefonoController.dispose();
    _passwordActualController.dispose();
    _nuevoPasswordController.dispose();
    _confirmarPasswordController.dispose();
    super.dispose();
  }
}