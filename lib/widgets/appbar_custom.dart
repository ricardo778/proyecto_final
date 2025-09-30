import 'package:flutter/material.dart';
import '../servicios/tema_service.dart';

class AppBarCustom extends StatelessWidget implements PreferredSizeWidget {
  final String titulo;
  final List<Widget>? acciones;
  final bool mostrarIconoAtras;

  const AppBarCustom({
    required this.titulo,
    this.acciones,
    this.mostrarIconoAtras = false,
  });

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        titulo,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      centerTitle: true,
      backgroundColor: TemaService.colorPrimario,
      foregroundColor: Colors.white,
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.3),
      automaticallyImplyLeading: mostrarIconoAtras,
      actions: acciones,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(15),
        ),
      ),
    );
  }
}