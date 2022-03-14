class FoodWastePost {
  var date;
  var imageUrl;
  var numOfEntities;
  var latitude;
  var longitude;

  FoodWastePost.fromMap(var entry) {
    this.date = entry['date'];
    this.imageUrl = entry['imageUrl'];
    this.numOfEntities = entry['numOfEntities'];
    this.latitude = entry['latitude'];
    this.longitude = entry['longitude'];
  }
}