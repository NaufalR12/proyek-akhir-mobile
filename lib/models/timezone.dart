class Timezone {
  final String name;
  final String code;
  final int offset;

  Timezone({
    required this.name,
    required this.code,
    required this.offset,
  });

  static List<Timezone> getTimezones() {
    return [
      Timezone(
        name: 'Waktu Indonesia Barat',
        code: 'WIB',
        offset: 7,
      ),
      Timezone(
        name: 'Waktu Indonesia Tengah',
        code: 'WITA',
        offset: 8,
      ),
      Timezone(
        name: 'Waktu Indonesia Timur',
        code: 'WIT',
        offset: 9,
      ),
      Timezone(
        name: 'London',
        code: 'GMT',
        offset: 0,
      ),
      Timezone(
        name: 'New York',
        code: 'EST',
        offset: -5,
      ),
      Timezone(
        name: 'Tokyo',
        code: 'JST',
        offset: 9,
      ),
    ];
  }
}
