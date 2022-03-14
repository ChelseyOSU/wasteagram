import 'package:test/test.dart';
import '../lib/models/food_waste_post.dart';

void main () {
  test('Post created from Map should have appropriate property values', () {
    final date = DateTime.parse('2022-01-01');
    const imageUrl = 'FAKE_URL';
    const numOfEntities = 1;
    const latitude = 1.0;
    const longitude = 2.0;

    final food_waste_post = FoodWastePost.fromMap({
      'date': date,
      'imageUrl': imageUrl,
      'numOfEntities': numOfEntities,
      'latitude': latitude,
      'longitude': longitude
    });

    expect(food_waste_post.date, date);
    expect(food_waste_post.imageUrl, imageUrl);
    expect(food_waste_post.numOfEntities, numOfEntities);
    expect(food_waste_post.latitude, latitude);
    expect(food_waste_post.longitude, longitude);
  });
}