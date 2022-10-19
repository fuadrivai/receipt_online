// ignore_for_file: non_constant_identifier_names

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

  @POST(
      "lazada-order/rts/{tracking_number}/{shipment_provider}/{order_item_ids}")
  Future<dynamic> orderRts(@Path() String tracking_number,
      @Path() String shipment_provider, @Path() List<int>? order_item_ids);

  @GET("lazada-order/{orderId}")
  Future<Order> getOrder(@Path() int orderId);

  @GET("lazada-order/pending")
  Future<FullOrder> getPendingOrder();

  @GET("lazada-order/rts")
  Future<FullOrder> getRtsOrder();

  @GET("lazada-order/packed")
  Future<FullOrder> getPackedOrder();

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
