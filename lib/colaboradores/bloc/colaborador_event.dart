import 'package:homejourney_appmovile/models/colaborador_model.dart';

abstract class ColaboradorEvent {}

class LoadColaboradores extends ColaboradorEvent {}

class AddColaborador extends ColaboradorEvent {
  final CreatePersonaColaboradorDto colaborador;

  AddColaborador(this.colaborador);
}

class UpdateColaborador extends ColaboradorEvent {
  final int id;
  final CreatePersonaColaboradorDto colaborador;

  UpdateColaborador(this.id, this.colaborador);
}

class DeleteColaborador extends ColaboradorEvent {
  final int id;

  DeleteColaborador(this.id);
}

class LoadDropdownData extends ColaboradorEvent {}

