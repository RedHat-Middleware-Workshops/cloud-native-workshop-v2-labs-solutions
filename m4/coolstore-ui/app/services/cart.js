'use strict';

angular.module("app")

.factory('cart', ['$http', '$q', 'COOLSTORE_CONFIG', 'Auth', '$location', function($http, $q, COOLSTORE_CONFIG, $auth, $location) {
	var factory = {}, cart, products, cartId, baseUrl;

 	baseUrl = $location.protocol() + '://cart-' + COOLSTORE_CONFIG.OCP_NAMESPACE + '.' + $location.host().replace(/^.*?\.(.*)/g,"$1") + '/api/cart';
	// Following used for local testing
 	// baseUrl = 'http://localhost:8081/api/cart';


	factory.checkout_withBilling = function(ccinfo){
		var deferred = $q.defer();
		var orderId = "order-" + (Math.floor(Math.random() * 10000)) + "-" + cartId;
        let billingInfo = {"orderId": orderId ,"total": cart.total, "creditCard": {"number": ccinfo.creditCard,"expiration": ccinfo.month+"/"+ccinfo.year,"nameOnCard": ccinfo.nameOnCard}, "billingAddress": ccinfo.shippingAddress, "name": ccinfo.nameOnCard};
        $http({
            method:'POST',
            url: baseUrl + '/checkout/' + cartId,
            data: billingInfo,
            headers: {
                'Content-Type': 'application/json'
            }
        }).then(function(resp) {
            cart = resp.data;
            deferred.resolve(resp.data);
        }, function(err) {
            deferred.reject(err);
        });
        return deferred.promise;
    };

	factory.checkout = function() {
		var deferred = $q.defer();
		$http({
			   method: 'POST',
			   url: baseUrl + '/checkout/' + cartId
		   }).then(function(resp) {
			    cart = resp.data;
			   	deferred.resolve(resp.data);
		   }, function(err) {
			   	deferred.reject(err);
		   });
		return deferred.promise;
	};

	factory.reset = function() {
		cart = {
			shoppingCartItemList: []
		};
		var tmpId = localStorage.getItem('cartId');
		var authId = $auth.userInfo ? $auth.userInfo.sub : null;

		if (tmpId && authId) {
			// transfer cart
			cartId = authId;
			this.setCart(tmpId).then(function(result) {
				localStorage.removeItem('cartId');
			}, function(err) {
				console.log("could not transfer cart " + tmpId + " to cart " +  authId + ": " + err);
			});
			return;
		}

		if (tmpId && !authId) {
			cartId = tmpId;
		}

		if (!tmpId && authId) {
			cartId = authId;
		}

		if (!tmpId && !authId) {
			tmpId = 'id-' + Math.random();
			localStorage.setItem('cartId', tmpId);
			cartId = tmpId;
		}

		cart.shoppingCartItemList = [];
		$http({
			   method: 'GET',
			   url: baseUrl + '/' + cartId
		   }).then(function(resp) {
			    cart = resp.data;
		   }, function(err) {
		});

	};

	factory.getCart = function() {
		return cart;
	};

	factory.removeFromCart = function(product, quantity) {
		var deferred = $q.defer();
		$http({
			method: 'DELETE',
			url: baseUrl + '/' + cartId + '/' + product.itemId + '/' + quantity
		}).then(function(resp) {
			cart = resp.data;
			deferred.resolve(resp.data);
		}, function(err) {
			deferred.reject(err);
		});
		return deferred.promise;

	};

	factory.setCart = function(id) {
		var deferred = $q.defer();
		$http({
			method: 'POST',
			url: baseUrl + '/' + cartId + '/' + id
		}).then(function(resp) {
			cart = resp.data;
			deferred.resolve(resp.data);
		}, function(err) {
			deferred.reject(err);
		});
		return deferred.promise;

	};

	factory.addToCart = function(product, quantity) {
		var deferred = $q.defer();
		$http({
			   method: 'POST',
			   url: baseUrl + '/' + cartId + '/' + product.itemId + '/' + quantity
		   }).then(function(resp) {
			    cart = resp.data;
			   	deferred.resolve(resp.data);
		   }, function(err) {
			   	deferred.reject(err);
		   });
		return deferred.promise;

	};

	factory.reset();
	return factory;
}]);
