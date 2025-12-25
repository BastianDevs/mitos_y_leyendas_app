import 'package:mitos_y_leyendas_app/domain/entities/edition.dart';

class LocalEditionsDatasource {
  List<EditionEntity> getEditions() {
    return [
      EditionEntity(
        id: 162,
        slug: 'kvsm_titanes',
        title: 'IMP - Kaiju vs Mecha - Titanes',
      ),
      EditionEntity(id: 161, slug: 'libertadores', title: 'IMP - Libertadores'),
      EditionEntity(id: 160, slug: 'onyria', title: 'IMP - Onyria'),
      EditionEntity(
        id: 156,
        slug: 'toolkit_cenizas_de_fuego',
        title: 'IMP - Cenizas de Fuego',
      ),
      EditionEntity(
        id: 155,
        slug: 'toolkit_hielo_inmortal',
        title: 'IMP - Hielo Inmortal',
      ),
      EditionEntity(
        id: 150,
        slug: 'lootbox_2024',
        title: 'IMP - Lootbox Imperio 2024',
      ),
      EditionEntity(
        id: 149,
        slug: 'secretos_arcanos',
        title: 'IMP - Secretos Arcanos',
      ),
      EditionEntity(id: 148, slug: 'bestiarium', title: 'IMP - Bestiarium'),
      EditionEntity(
        id: 137,
        slug: 'escuadronmecha',
        title: 'IMP - Escuadrón Mecha',
      ),
      EditionEntity(
        id: 136,
        slug: 'amenazakaiju',
        title: 'IMP - Amenaza Kaiju',
      ),
      EditionEntity(id: 126, slug: 'zodiaco', title: 'IMP - Zodiaco'),
      EditionEntity(
        id: 125,
        slug: 'espiritu_samurai',
        title: 'IMP - Espíritu Samuráis',
      ),
    ];
  }
}
