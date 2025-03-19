abstract class ColaboradorSucursalEvent {}

class LoadColaboradoresSucursales extends ColaboradorSucursalEvent {}

class AddColaboradorSucursal extends ColaboradorSucursalEvent {
  final int colaboradorId;
  final int sucursalId;
  final double distanciaKilometro;
  final int usuarioCrea;

  AddColaboradorSucursal({
    required this.colaboradorId,
    required this.sucursalId,
    required this.distanciaKilometro,
    required this.usuarioCrea,
  });
}

class UpdateColaboradorSucursal extends ColaboradorSucursalEvent {
  final int id;
  final int colaboradorId;
  final int sucursalId;
  final double distanciaKilometro;
  final int usuarioModifica;

  UpdateColaboradorSucursal({
    required this.id,
    required this.colaboradorId,
    required this.sucursalId,
    required this.distanciaKilometro,
    required this.usuarioModifica,
  });
}

class SetActiveColaboradorSucursal extends ColaboradorSucursalEvent {
  final int id;
  final bool active;

  SetActiveColaboradorSucursal({
    required this.id,
    required this.active,
  });
}

