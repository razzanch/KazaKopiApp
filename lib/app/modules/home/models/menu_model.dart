class MenuModel {
  final String name;
  final String imageAsset;
  final String? route; // route diubah menjadi nullable

  MenuModel({required this.name, required this.imageAsset, this.route});
}
