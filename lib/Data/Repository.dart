import 'package:foodtrucks/Data/DBProvider.dart';
import 'package:foodtrucks/Modal/FoodTruck.dart';

class Repository {

  Future<List<FoodTruck>> getFoodTrucks() async {
    List<FoodTruck> foodTrucks = await DBProvider.db.getAllFoodTrucks();
    if (foodTrucks.length > 0) {
      return foodTrucks;
    } else {
      await addFoodTrucksToDatabase();
      List<FoodTruck> foodTrucksRetry = await DBProvider.db.getAllFoodTrucks();
      return foodTrucksRetry;
    }
  }

  addFoodTrucksToDatabase() async {
    await DBProvider.db.addFoodTruck(
      FoodTruck(
        id: 1,
        name: "Sorrento",
        type: "North Indian",
        openingTime: "06:30 AM",
        closingTime: "10:00 PM",
        address: "Hanuman Hindu Temple, Baba Kharak Singh Marg, Connaught Place, New Delhi, Delhi, 110001",
        lat: 28.6299085,
        long: 77.21509748,
      ),
    );
    await DBProvider.db.addFoodTruck(
      FoodTruck(
        id: 2,
        name: "Food Exchange",
        type: "Italian",
        openingTime: "10:00 AM",
        closingTime: "09:00 PM",
        address: "Convent of Jesus and Mary, Bangla Sahib Road, DIZ Area, New Delhi, Delhi, 110007",
        lat: 28.62859603,
        long: 77.20776006,
      ),
    );
    await DBProvider.db.addFoodTruck(FoodTruck(
      id: 3,
      name: "Jung Bahadur Kachori Wala",
      type: "North Indian",
      openingTime: "08:00 AM",
      closingTime: "10:00 PM",
      address: "Kasturba Gandhi Marg, Connaught Place, New Delhi, Delhi, 110001",
      lat: 28.62587181,
      long: 77.22402372,
    ));
    await DBProvider.db.addFoodTruck(FoodTruck(
      id: 4,
      name: "The Chinese Chicken Spot",
      type: "Chinese",
      openingTime: "11:00 AM",
      closingTime: "12:00 AM",
      address: "Hanuman Hindu Temple, Baba Kharak Singh Marg, Connaught Place, New Delhi, Delhi, 110001",
      lat: 28.63029968,
      long: 77.21452926,
    ));
    await DBProvider.db.addFoodTruck(FoodTruck(
      id: 5,
      name: "LA COZZA INFURIATA",
      type: "Italian",
      openingTime: "01:00 PM",
      closingTime: "12:00 AM",
      address: "Jantar Mantar, Sansad Marg, Connaught Place, New Delhi, Delhi, 110001",
      lat: 28.62736885,
      long: 77.21647777,
    ));
    await DBProvider.db.addFoodTruck(FoodTruck(
      id: 6,
      name: "Rockin' and Ramen",
      type: "Chinese",
      openingTime: "12:00 PM",
      closingTime: "10:00 PM",
      address: "Barakhamba Road, New Delhi, Delhi, 110001",
      lat: 28.62902379,
      long: 77.22730504,
    ));
    await DBProvider.db.addFoodTruck(FoodTruck(
      id: 7,
      name: "NON TI PAGO",
      type: "Italian",
      openingTime: "12:00 PM",
      closingTime: "10:00 PM",
      address: "51/2 Basant Road, New Delhi, Delhi, 110055",
      lat: 28.63802175,
      long: 77.21442537,
    ));
    await DBProvider.db.addFoodTruck(FoodTruck(
      id: 8,
      name: "Souper Won Ton",
      type: "Chinese",
      openingTime: "01:00 PM",
      closingTime: "10:00 PM",
      address: "1/1 Hailey Road, New Delhi, Delhi, 110001",
      lat: 28.62664638,
      long: 77.2247733,
    ));
    await DBProvider.db.addFoodTruck(FoodTruck(
      id: 9,
      name: "Pind Balluchi",
      type: "North Indian",
      openingTime: "11:00 AM",
      closingTime: "11:00 PM",
      address: "5/12 Jantar Mantar Road, New Delhi, Delhi, 110001",
      lat: 28.62428949,
      long: 77.21624218,
    ));
    await DBProvider.db.addFoodTruck(FoodTruck(
      id: 10,
      name: "Szechuan Delight",
      type: "Chinese",
      openingTime: "10:30 AM",
      closingTime: "11:00 PM",
      address: "H-78 Jai Singh Marg, New Delhi, Delhi, 110001",
      lat: 28.62510391,
      long: 77.21090717,
    ));
  }
}
