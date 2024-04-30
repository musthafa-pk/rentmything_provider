class AppUrl{

  // ip address from office network
  // static var baseUrl = 'http://192.168.1.12:3006';

  //ip address from my office lap
  // static var baseUrl = 'http://192.168.1.5:3005';

  //ip address from mobile network
  // static var baseUrl = 'http://192.168.151.96:3005';

  //ip address from hosted network
  static var baseUrl = 'http://3.109.180.229:3006';

  //auth api
  static String loginApi = '$baseUrl/user/login';


  //user api

  static String userDetails = '$baseUrl/user/userdetails';

  static String userAdd = '$baseUrl/user/usersadd';

  static String userEdit = '$baseUrl/user/editUser';

  static String forgotpwd = '$baseUrl/user/forgotPwd';

  static String resetPassword = '$baseUrl/user/resetPwd';

  static String loginwithotp = '$baseUrl/user/otpLogin';

  static String emailVerifiication = '$baseUrl/user/emailverification';

  //category api

  static String getallCategory = '$baseUrl/categorysub/allcategories';

  static String getCategory = '$baseUrl/categorysub/getcategory';

  static String getSubCategory = '$baseUrl/categorysub/getsubcategory';

  static String getProductByCategory = '$baseUrl/categorysub/productlist';

  //cart & wishlist

  static String wishlistAdd = '$baseUrl/wishlist/wishlistadd';

  static String wishlistget = '$baseUrl/wishlist/getwishlist';

  static String getCart = '$baseUrl/cart/getcart';

  static String addtoCart = '$baseUrl/cart/cartadd';

  //products api

  static String addProduct = '$baseUrl/products/productsadd';

  static String listProducts  = '$baseUrl/products/prodlist';

  static String getProductDetials = '$baseUrl/products/productdetails';

  static String getProductbycatego = '$baseUrl/products/prodcategory';

  static String deleteproduct = '$baseUrl/products/deleteproduct';

  //popular products
  static String listPopular = '$baseUrl/products/popularproduct';

  //wishlist
  static String getwishlist = '$baseUrl/wishlist/getwishlist';

  //addtorent
  static String addrentdata = '$baseUrl/rent/addrentdata';
  //rented Data getting
  static String getRentedData = '$baseUrl/rent/renteddata';
  // itemsearch
  static String searchapi = '$baseUrl/products/search';

  // notification
  static String getnotification = "$baseUrl/notification/cus_getnotification";

  static String readnotification = '$baseUrl/notification/readnotification';

  static String deletenotification = '$baseUrl/notification/deletenotification';

  //chat list
  static String chatlist = '$baseUrl/chat/chatlist';
  static String getsinglechat = '$baseUrl/chat/fullchat';
  static String sendmessage = '$baseUrl/chat/savechat';
}