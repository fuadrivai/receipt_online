import 'package:dio/dio.dart';
import 'package:receipt_online_shop/model/daily_task.dart';
import 'package:receipt_online_shop/model/lazada/order.dart';
import 'package:receipt_online_shop/model/receipt.dart';
import 'package:receipt_online_shop/screen/expedition/data/expedition.dart';
import 'package:retrofit/http.dart';

import '../model/lazada/full_order.dart';

part 'restclient.g.dart';

@RestApi()
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET("lazada-order/{orderId}")
  Future<Order> getOrder(@Path() int orderId);

  @GET("lazada-order")
  Future<FullOrder> getOrders();

  @GET("daily-task/receipt/{id}")
  Future<Receipt> receiptByDailyTaskId(@Path() int id);

  @POST("daily-task/receipt/{id}")
  Future<dynamic> dailyTaskPostReceipt(@Path() int id, @Body() Receipt receipt);

  @DELETE("daily-task/receipt/{number}")
  Future<dynamic> deleteReceipt(@Path() String number);

  @GET("daily-task/current")
  Future<List<DailyTask>> findCurrentDailyTask();

  @GET("daily-task/{id}")
  Future<DailyTask> dailyTaskFindById(@Path() int id);

  @POST("daily-task")
  Future<DailyTask> postDailyTask(@Body() DailyTask dailyTask);

  @GET("expedition")
  Future<List<Expedition>> findAllExpedition();

  @GET("expedition/{id}")
  Future<Expedition> expeditionFindById(@Path() int id);

  @POST("expedition")
  Future<Expedition> postExpedition(@Body() Expedition expedition);

  @PUT("expedition/{id}")
  Future expeditionEdit(@Path() int id, @Body() Expedition cst);

  // @GET("sales/{id}")
  // Future<Salesman> salesmanFindById(@Path() String id);

  // @GET("customer")
  // Future<List<Customer>> findAllCustomer();

  // @GET("customer/{id}")
  // Future<Customer> customerFindById(@Path() String id);

}
