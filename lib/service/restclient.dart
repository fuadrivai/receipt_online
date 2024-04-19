// ignore_for_file: non_constant_identifier_names

import 'package:dio/dio.dart';
import 'package:receipt_online_shop/model/daily_task.dart';
import 'package:receipt_online_shop/model/expired_token.dart';
import 'package:receipt_online_shop/model/lazada/lazada_count.dart';
import 'package:receipt_online_shop/model/platform.dart';
import 'package:receipt_online_shop/model/receipt.dart';
import 'package:receipt_online_shop/model/serverside.dart';
import 'package:receipt_online_shop/model/transaction_online.dart';
import 'package:receipt_online_shop/screen/expedition/data/expedition.dart';
import 'package:receipt_online_shop/screen/product/data/product.dart';
import 'package:retrofit/http.dart';

import '../model/lazada/full_order.dart';

part 'restclient.g.dart';

@RestApi()
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET("/platform")
  Future<List<Platform>> getPlatforms();
  @GET("/platform/active")
  Future<List<Platform>> getActivePlatform();

  @POST("/shopee-order/rts/{orderSn}")
  Future shopeeRts(@Path() String orderSn);

  @GET("/jd-order/rts/{id}")
  Future jdIdRts(@Path() String id);

  @POST("/transaction-online")
  Future<TransactionOnline> postTransactionOnline(
      @Body() TransactionOnline dataOnline);

  @GET("/lazada/order/{status}/{sorting}")
  Future<List<TransactionOnline>> lazadaGetFullOrder(
      @Path() String status, @Path() String sorting);

  @GET("/jd-order/{orderSn}")
  Future<TransactionOnline> getJdIdOrderByNo(@Path() String orderSn);
  @GET("/shopee-order")
  Future<List<TransactionOnline>> getShopeeOrders();

  @GET("/tiktok-order/get")
  Future<List<TransactionOnline>> getTiktokOrders();

  @GET("/tiktok-order/get/{orderSn}")
  Future<List<TransactionOnline>> getTiktokOrder(@Path() String orderSn);

  @GET("/shopee-order/order/v2/{orderSn}")
  Future<List<TransactionOnline>> getShopeeOrderByNo(@Path() String orderSn);

  @POST(
      "lazada-order/rts/{tracking_number}/{shipment_provider}/{order_item_ids}")
  Future<dynamic> orderRts(@Path() String tracking_number,
      @Path() String shipment_provider, @Path() List<int>? order_item_ids);

  @GET("/lazada-order/link")
  Future<String> lazadaAuthLink();

  @GET("/lazada-order/auth-date")
  Future<ExpiredToken> lazadaAuthDate();

  @GET("/lazada-order/token/refresh")
  Future lazadaRefreshToken();

  @GET("/lazada-order/count")
  Future<LazadaCount> lazadaGetCount();

  @GET("/lazada-order/{orderId}")
  Future<TransactionOnline> getOrder(@Path() String orderId);

  @GET("/lazada-order/pending/{sorting}")
  Future<FullOrder> getPendingOrder(@Path() String sorting);

  @GET("/lazada-order/rts/{sorting}")
  Future<FullOrder> getRtsOrder(@Path() String sorting);

  @GET("/lazada-order/packed/{sorting}")
  Future<FullOrder> getPackedOrder(@Path() String sorting);

  @GET("/daily-task/receipt/{id}")
  Future<Receipt> receiptByDailyTaskId(@Path() int id);

  @POST("/daily-task/receipt/{id}")
  Future<dynamic> dailyTaskPostReceipt(@Path() int id, @Body() Receipt receipt);

  @DELETE("/daily-task/receipt/{number}")
  Future<dynamic> deleteReceipt(@Path() String number);

  @DELETE("/daily-task/{id}")
  Future<dynamic> deleteDailyTask(@Path() int id);

  @GET("/daily-task/current")
  Future<List<DailyTask>> findCurrentDailyTask();

  @GET("/daily-task/{id}")
  Future<DailyTask> dailyTaskFindById(@Path() int id);

  @PATCH("/daily-task/finish/{id}")
  Future<dynamic> finishDailyTask(@Path() int id);

  @POST("/daily-task")
  Future<void> postDailyTask(@Body() DailyTask dailyTask);

  @GET("/expedition")
  Future<List<Expedition>> findAllExpedition();

  @GET("/expedition/{id}")
  Future<Expedition> expeditionFindById(@Path() int id);

  @POST("/expedition")
  Future<Expedition> postExpedition(@Body() Expedition expedition);

  @PUT("/expedition/{id}")
  Future expeditionEdit(@Path() int id, @Body() Expedition cst);

  @GET("/product/{barcode}")
  Future<Product> getProductByBarcode(@Path() String barcode);
  @GET("/product")
  Future<ServerSide> getProducts();

  // @GET("/sales/{id}")
  // Future<Salesman> salesmanFindById(@Path() String id);

  // @GET("/customer")
  // Future<List<Customer>> findAllCustomer();

  // @GET("/customer/{id}")
  // Future<Customer> customerFindById(@Path() String id);
}
