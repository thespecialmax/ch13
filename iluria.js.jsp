









Iluria = function() {}

Iluria.cart = function() {}
Iluria.clientAccount = function() {}

Iluria.cart.width = 750;
Iluria.cart.height = 480;

Iluria.clientAccount.width = 750;
Iluria.clientAccount.height = 450;

Iluria.isTestEnvironment = function() {
	return false;
}

Iluria.readClientProductComment = function(form, callback) {
	$.ajax({
		url: "/clientServices.do?command=readClientProductComment" + "&r=" + Math.random(),
		data: $(form).serialize(),
		type: "POST",
		async: true,
		cache: false,
		contentType : "application/x-www-form-urlencoded; charset=utf-8",
		success: function(responseData, status, xhr) {
			callback.call();
		},
		error: function(xhr, status, error) {
			callback.call("error");
		}
	});
}

Iluria.loginUser = function() {
	
	var redirectUrl = location;
	redirectUrl = "/";
	
	var view = $("#iluria-view");

	if(view.size() == 0)
		$("body").append("<div id='iluria-view' style='display: none'/>");

	$("#iluria-view").html("<div />");
	
	$("#iluria-view").prettyPhoto({
		theme: 'facebook', 
		hideflash: 'true',
		allowresize: false,
		showTitle: false,
		iframe_markup: '<iframe src ="{path}" width="{width}" height="{height}" frameborder="no" scrolling="no"></iframe>'
	});
	$.prettyPhoto.open(
		'http://shopconnect.iluria.com/shopconnect/shopconnect.do'
			+ '?command=showLoginForm'
			+ '&locale=pt-br'
			+ '&r=' + Math.random() 
			+ '&redirectUrl=' + encodeURIComponent(redirectUrl) 
			+ '&iframe=true&width=700&height=355',
				'',
				
					"<span style='padding-left: 15px; font-family: \"lucida grande\",tahoma,verdana,arial,sans-serif; font-size: 11px; font-weight: bold; color: #000000'></span>"
				
	);	
}

Iluria.logoutUser = function() {
	$.ajax({
		url: "/clientServices.do?command=logoutClient",
		type: "GET",
		async: true,
		cache: false,
		success: function(responseData, status, xhr) {
			if (window.location.protocol === "https:") {
				window.location = 'https://www.raizefoia.com.br/clientServices.do?command=logoutClient&redirect=true';
			} else {
				window.location = 'https://469a8.iluria.com/clientServices.do?command=logoutClient&redirect=true';
			}
		},
		error: function(xhr, status, error) {
		}
	});
}

Iluria.showProductPictureZoom = function(productId, pictureId, variationId) {
	Iluria.initView(765, 450, function() {
		Iluria.loadView("/webCommons/includes/product/zoom.jsp?rand="+Math.random(), 
			"pictureId=" + pictureId + "&productId=" + productId+"&variationId="+variationId, 
			function(response) {
				Iluria.showView(response);			
			});
	});
}


Iluria.addSoldoutNotify = function(productId) {
		
	
	
	Iluria.initView(400, 165, function() {
	
		Iluria.loadView("/soldOutNotification.do?command=showAddSoldoutProductNotifyForm&productId=" + productId, 
			function(response, status) {
				
					Iluria.showView(response);
				
			});
	});
}


Iluria.addVariationSoldoutNotify = function(productId, variationId) {
		
	
	
	Iluria.initView(400, 165, function() {
	
		Iluria.loadView("/soldOutNotification.do?command=showAddSoldoutProductNotifyForm&productId=" + productId + "&variationId="+variationId, 
			function(response, status) {
				
					Iluria.showView(response);
				
			});
	});
}

Iluria.readAddSoldoutNotifyForm = function() {
	var form = $("#notifyForm");
	var data = form.serialize();
	Iluria.showViewProgress(Iluria.cart.width, Iluria.cart.height);
	Iluria.loadView("/soldOutNotification.do", data, 
		function(response, status) {
			if(status == 10001)
				alert("E-mail j\u00E1 cadastrado para este produto.");
			else
				alert("E-mail cadastrado com sucesso!");
			$.prettyPhoto.close();
	}, "POST");
}

Iluria.addToCart = function(productId) {
	

	
	
	var variationId1 = $("#iluria-product-variation1").val();
	var variationId2 = $("#iluria-product-variation2").val();
	var variationId3 = $("#iluria-product-variation3").val();
	
	if(variationId1=="0" || variationId2=="0" || variationId3=="0"){
		alert("Selecione a varia\u00E7\u00E3o do produto.");
		return;
	}
	
	Iluria.initView(Iluria.cart.width, Iluria.cart.height, function() {

		Iluria.loadView("/cart.do?command=addToCart&productId=" + productId + "&productVariationId1=" + variationId1 + "&productVariationId2=" + variationId2 + "&productVariationId3=" + variationId3, 
			function(response, status) {
				if(status == 10005) {
					alert("Este produto está fora de estoque.");
					$.prettyPhoto.close();
					return;
				} else if (status == 10014) {
					alert("Não foi possível calcular o frete pois alguns produtos estão\nsem informação de peso e medidas. Para finalizar o pedido,\npor gentileza entre em contato com nosso atendimento para\nque possamos informar o valor do frete.");
					$.prettyPhoto.close();
					return;
				} else {
					Iluria.showView(response);
				}
			});
	});
}

Iluria.removeFromCart = function(productId, variationId) {
	Iluria.showViewProgress(Iluria.cart.width, Iluria.cart.height);
	Iluria.loadView("/cart.do?command=removeFromCart&productId=" + productId + "&variationId=" + variationId + "&r=" + Math.random(), 
		function(response) {
			Iluria.showView(response);			
	});
}

Iluria.cart.selectShippingType = function (shippingType) {
	Iluria.showViewProgress(Iluria.cart.width, Iluria.cart.height);
	Iluria.loadView("/cart.do?command=updateShippingType&shippingType=" + shippingType + "&r=" + Math.random(),
		function(response, status) {
			if(status == 10004) {
				Iluria.loadView("/cart.do?command=showCart" + "&r=" + Math.random(),
					function(response) {
						Iluria.showView(response);			
						alert("Não foi possível calcular o frete automaticamente porque o peso ou volume dos produtos excede o máximo permitido pelos Correios. Calcularemos o valor do frete e avisaremos você por email.");
					});
			}
			if(status == 10003) {
				Iluria.loadView("/cart.do?command=showCart" + "&r=" + Math.random(),
					function(response) {
						Iluria.showView(response);			
						alert("Não foi possível calcular o frete para o CEP informado.\nO CEP pode estar errado ou o serviço de cálculo de frete\ndos Correios pode estar fora do ar. Para finalizar o pedido,\npor gentileza entre em contato com nosso atendimento\npara que possamos informar o valor do frete.");
					});
			}
			if(status == 10015) {
				Iluria.loadView("/cart.do?command=showCart" + "&r=" + Math.random(),
					function(response) {
						Iluria.showView(response);			
						alert("O CEP informado não existe.");
					});
			}
			if(status == 10021) {
				Iluria.loadView("/cart.do?command=showCart" + "&r=" + Math.random(),
					function(response) {
						Iluria.showView(response);			
						alert("Este CEP está fora da região de entrega da loja.");
					});
			}
			if(status == 10014) {
				Iluria.loadView("/cart.do?command=showCart" + "&r=" + Math.random(),
					function(response) {
						Iluria.showView(response);			
						alert("Não foi possível calcular o frete pois alguns produtos estão\nsem informação de peso e medidas. Para finalizar o pedido,\npor gentileza entre em contato com nosso atendimento para\nque possamos informar o valor do frete.");
					});
			}
			if(status = 200) {
				Iluria.showView(response);
				$("#zip").focus();			
			}
		});
}

Iluria.cart.reloadCart = function() {
	Iluria.showViewProgress(Iluria.cart.width, Iluria.cart.height);
	Iluria.loadView("/cart.do?command=showCart&r=" + Math.random(), 
		function(response) {
			Iluria.showView(response);			
		});
}

// Iluria.cart.calculateShipping = function (zip) {
// 	Iluria.showViewProgress(Iluria.cart.width, Iluria.cart.height);
// 	Iluria.loadView("/cart.do?command=calculateShipping&zip=" + zip, 
// 		 function(response) {
// 			Iluria.showView(response);			
// 	});
// }

Iluria.cart.calculateShipping = function (zip) {
	Iluria.showViewProgress(Iluria.cart.width, Iluria.cart.height);
	Iluria.loadView("/cart.do?command=calculateShipping&zip=" + zip + "&r=" + Math.random(), 
		function(response, status) {
			if(status == 10004) {
				Iluria.loadView("/cart.do?command=showCart" + "&r=" + Math.random(),
					function(response) {
						Iluria.showView(response);			
						alert("Não foi possível calcular o frete automaticamente porque o peso ou volume dos produtos excede o máximo permitido pelos Correios. Calcularemos o valor do frete e avisaremos você por email.");
					});
			}
			if(status == 10003) {
				Iluria.loadView("/cart.do?command=showCart" + "&r=" + Math.random(),
					function(response) {
						Iluria.showView(response);			
						alert("Não foi possível calcular o frete para o CEP informado.\nO CEP pode estar errado ou o serviço de cálculo de frete\ndos Correios pode estar fora do ar. Para finalizar o pedido,\npor gentileza entre em contato com nosso atendimento\npara que possamos informar o valor do frete.");
					});
			}
			
			if(status == 10015) {
				Iluria.loadView("/cart.do?command=showCart" + "&r=" + Math.random(),
					function(response) {
						Iluria.showView(response);			
						alert("O CEP informado não existe.");
					});
			}
			if(status == 10021) {
				Iluria.loadView("/cart.do?command=showCart" + "&r=" + Math.random(),
					function(response) {
						Iluria.showView(response);			
						alert("Este CEP está fora da região de entrega da loja.");
					});
			}
			if(status == 10014) {
				Iluria.loadView("/cart.do?command=showCart" + "&r=" + Math.random(),
					function(response) {
						Iluria.showView(response);			
						alert("Não foi possível calcular o frete pois alguns produtos estão\nsem informação de peso e medidas. Para finalizar o pedido,\npor gentileza entre em contato com nosso atendimento para\nque possamos informar o valor do frete.");
					});
			}
			if(status = 200) {
				Iluria.showView(response);			
			}
		});
}
			
Iluria.cart.showClientInfoForm = function () {
	Iluria.showViewProgress(Iluria.cart.width, Iluria.cart.height);
	Iluria.loadView("/cart.do?command=showClientInfoForm" + "&r=" + Math.random(), 
		function(response) {
			Iluria.showView(response);			
	});
}

Iluria.saveCartComments = function(commentsFormId) {
	var form = $("#" + commentsFormId);
	var data = form.serialize();
	Iluria.showViewProgress(Iluria.cart.width, Iluria.cart.height);
	Iluria.loadView("/cart.do?command=updateComments" + "&r=" + Math.random(), data, 
		function(response) {
			Iluria.showView(response);			
	}, "POST");
}

Iluria.saveCartCoupon= function(commentsFormId) {
	var form = $("#" + commentsFormId);
	var data = form.serialize();
	//Iluria.showViewProgress(Iluria.cart.width, Iluria.cart.height);
	Iluria.loadView("/cart.do?command=updateCoupon" + "&r=" + Math.random(), data, 
		function(response, status) {
			if(status == 10006) {
				Iluria.loadView("/cart.do?command=showCart" + "&r=" + Math.random(),
					function(response) {
						Iluria.showView(response);			
						alert("Cupom inválido.");
					});
			}
			Iluria.showView(response);			
	}, "POST");
}

Iluria.saveDepositDiscountOption= function(commentsFormId) {
	var form = $("#" + commentsFormId);
	var data = form.serialize();
	//Iluria.showViewProgress(Iluria.cart.width, Iluria.cart.height);
	Iluria.loadView("/cart.do?command=updateDepositDiscount" + "&r=" + Math.random(), data, 
		function(response, status) {
			if(status == 10006) {
				Iluria.loadView("/cart.do?command=showCart" + "&r=" + Math.random(),
					function(response) {
						Iluria.showView(response);
					});
			}
			Iluria.showView(response);			
	}, "POST");
}

Iluria.cart.showClientAddressForm = function () {
	Iluria.showViewProgress(Iluria.cart.width, Iluria.cart.height);
	Iluria.loadView("/cart.do?command=showClientAddressForm" + "&r=" + Math.random(), 
		function(response) {
			Iluria.showView(response);			
	});
}

Iluria.cart.backFromClientAddress = function() {
	var form = $("#clientDataForm");
	var data = form.serialize();
	Iluria.showViewProgress(Iluria.cart.width, Iluria.cart.height);
	Iluria.loadView("/cart.do?command=saveClientAddress" + "&r=" + Math.random(), data, 
		function(response) {
			Iluria.cart.reloadCart();
	}, "POST");
}

Iluria.cart.nextFromClientAddress = function() {
	var form = $("#clientDataForm");
	var data = form.serialize();
	Iluria.showViewProgress(Iluria.cart.width, Iluria.cart.height);
	Iluria.loadView("/cart.do?command=saveClientAddress" + "&r=" + Math.random(), data, 
		function(response) {
			Iluria.loadView("/cart.do?command=showClientInfoForm" + "&r=" + Math.random(), 
				function(response) {
					Iluria.showView(response);			
			});
	}, "POST");
}

Iluria.cart.backFromClientInfoToClientAddress = function() {
	var form = $("#clientDataForm");
	var data = form.serialize();
	Iluria.showViewProgress(Iluria.cart.width, Iluria.cart.height);
	Iluria.loadView("/cart.do?command=saveClientInfo" + "&r=" + Math.random(), data, 
		function(response) {
			Iluria.loadView("/cart.do?command=showClientAddressForm" + "&r=" + Math.random(), 
				function(response) {
					Iluria.showView(response);			
			});
	}, "POST");
}

Iluria.cart.backFromClientInfoToCart = function() {
	var form = $("#clientDataForm");
	var data = form.serialize();
	Iluria.showViewProgress(Iluria.cart.width, Iluria.cart.height);
	Iluria.loadView("/cart.do?command=saveClientInfo" + "&r=" + Math.random(), data, 
		function(response) {
			Iluria.cart.reloadCart();
	}, "POST");
}

Iluria.cart.nextFromClientInfoToPayment = function() {
	var form = $("#clientDataForm");
	var data = form.serialize();
	Iluria.showViewProgress(Iluria.cart.width, Iluria.cart.height);
	Iluria.loadView("/cart.do?command=saveClientInfo" + "&r=" + Math.random(), data, 
		function(response) {
			Iluria.cart.showPaymentForm();
	}, "POST");
}

Iluria.cart.submitOrderManual = function() {
	var form = $("#clientDataForm");
	var data = form.serialize();
	Iluria.showViewProgress(Iluria.cart.width, Iluria.cart.height);
	Iluria.loadView("/cart.do?command=saveClientInfo" + "&r=" + Math.random(), data, 
		function(response) {
			Iluria.cart.submitOrder();
	}, "POST");
}

Iluria.cart.showPaymentForm = function () {
	Iluria.showViewProgress(Iluria.cart.width, Iluria.cart.height);
	Iluria.loadView("/cart.do?command=showPaymentForm" + "&r=" + Math.random(), 
		function(response) {
			Iluria.showView(response);			
	});
}



Iluria.cart.backFromPaymentInfo = function() {
	var form = $("#clientDataForm");
	var data = form.serialize();
	Iluria.showViewProgress(Iluria.cart.width, Iluria.cart.height);
	Iluria.loadView("/cart.do?command=savePaymentInfo" + "&r=" + Math.random(), data, 
		function(response) {
			Iluria.cart.showClientInfoForm();
	}, "POST");
}

Iluria.cart.submitMercadoPago = function() {
	var form = $("#iluria-cart-payment-form-mercado-pago");
	var data = form.serialize();
	Iluria.showViewProgress(Iluria.clientAccount.width, Iluria.clientAccount.height);
	Iluria.loadView("/cart.do?command=submitMercadoPagoPayment" + "&r=" + Math.random(), data, 
		function(response, status) {
			if(status == 10016)
			{
				alert("Não foi possível pagar usando o Mercado Pago.");
				Iluria.clientAccount.showClientOrderHistoryForm();
			}
			else if(status == 200)
			{
				document.location = response;
			}
			else
			{
				Iluria.clientAccount.showClientOrderHistoryForm();
			}
			
	}, "POST");
}

Iluria.cart.submitOrder = function() {
	var form = $("#clientDataForm");
	var data = form.serialize();
	Iluria.showViewProgress(Iluria.cart.width, Iluria.cart.height);
	Iluria.loadView("/cart.do?command=savePaymentInfo" + "&r=" + Math.random(), data, 
		function(response) {
			Iluria.loadView("/cart.do?command=submitOrder", 
				function(response) {
					if(response == null || response == "") {
						alert("Houve um erro inesperado ao enviar seu pedido. \n\nPor favor entre em contato com nosso atendimento para mais informações.");
						$.prettyPhoto.close();
						return;
					}
					else { 
						 alert("Para acompanhar o andamento do pedido, clique na opção 'Minha conta' na loja.\n\nSeu pedido foi enviado com sucesso."); 
						
						
						
						
						
						$("body").append("<div id='iluria-cart-payment-form-container' style='display: none'/>");
						$("#iluria-cart-payment-form-container").html(response);
					}						
			});
	}, "POST");
}

Iluria.updateQuantity = function(productId, quantity, variationId) {
	Iluria.showViewProgress(Iluria.cart.width, Iluria.cart.height);
	Iluria.loadView("/cart.do?command=updateQuantity&productId=" + productId + "&quantity=" + quantity+ "&variationId=" + variationId + "&r=" + Math.random(), 
		function(response, status) {
			if(status == 10001) {
				Iluria.loadView("/cart.do?command=showCart", 
					function(response) {
						Iluria.showView(response);			
						 alert("Quantidade menor que o mínimo permitido."); 
						
						
						
						
						
					});
			}
			if(status == 10002) {
				Iluria.loadView("/cart.do?command=showCart", 
					function(response) {
						Iluria.showView(response);			
						alert("Quantidade indisponível no estoque.");
					});
			}
			if(status == 10004) {
				Iluria.loadView("/cart.do?command=showCart" + "&r=" + Math.random(),
					function(response) {
						Iluria.showView(response);			
						alert("Não foi possível calcular o frete automaticamente porque o peso ou volume dos produtos excede o máximo permitido pelos Correios. Calcularemos o valor do frete e avisaremos você por email.");
					});
			}
			if(status == 10003) {
				Iluria.loadView("/cart.do?command=showCart" + "&r=" + Math.random(),
					function(response) {
						Iluria.showView(response);			
						alert("Não foi possível calcular o frete automaticamente porque o serviço de cálculo de frete dos Correios está fora do ar. Para finalizar o pedido, por gentileza entre em contato com nosso atendimento para que possamos informar o valor do frete.");
					});
			}
			if(status == 10015) {
				Iluria.loadView("/cart.do?command=showCart" + "&r=" + Math.random(),
					function(response) {
						Iluria.showView(response);			
						alert("O CEP informado não existe.");
					});
			}
			if(status == 10021) {
				Iluria.loadView("/cart.do?command=showCart" + "&r=" + Math.random(),
					function(response) {
						Iluria.showView(response);			
						alert("Este CEP está fora da região de entrega da loja.");
					});
			}
			if(status == 10014) {
				Iluria.loadView("/cart.do?command=showCart" + "&r=" + Math.random(),
					function(response) {
						Iluria.showView(response);			
						alert("Não foi possível calcular o frete pois alguns produtos estão\nsem informação de peso e medidas. Para finalizar o pedido,\npor gentileza entre em contato com nosso atendimento para\nque possamos informar o valor do frete.");
					});
			}
			if(status = 200) {
				Iluria.showView(response);			
			}
	});
}

Iluria.showCart = function() {
	

	Iluria.initView(Iluria.cart.width, Iluria.cart.height, function() {
		Iluria.loadView("/cart.do?command=showCart" + "&r=" + Math.random(), 
			function(response) {
				Iluria.showView(response);			
			});
	});
}

Iluria.clientAccount.showClientAccountForm = function () {
	Iluria.initView(Iluria.clientAccount.width, Iluria.clientAccount.height, function() {
		Iluria.loadView("/clientServices.do?command=showClientOrderHistoryForm" + "&r=" + Math.random(), 
			function(response) {
				Iluria.showView(response);			
		});
	});
}

Iluria.clientAccount.showClientInfoForm = function () {
	Iluria.showViewProgress(Iluria.clientAccount.width, Iluria.clientAccount.height);
	Iluria.loadView("/clientServices.do?command=showClientInfoForm" + "&r=" + Math.random(), 
		function(response) {
			Iluria.showView(response);			
	});
}

Iluria.clientAccount.subscribeNewsletter = function (email) {
	

	$.ajax({
		url: "/clientServices.do?command=subscribeNewsletter&email=" + email + "&r=" + Math.random(),
		type: "POST",
		async: true,
		cache: false,
		success: function(data, status, xhr) {

			if(data == '10000') {
				 alert("Email inválido"); 
			}

			if(data == '10001') {
				 alert("Seu email foi cadastrado com sucesso!"); 			
				$(".newsletter-email").val("Digite seu email");
			}

			if(data == '10002') {
				 alert("Esse email já está cadastrado."); 
			}
		}
	});
}

Iluria.clientAccount.subscribePopupNewsletter = function (email, name) {
	

	$.ajax({
		url: "/clientServices.do?command=subscribeNewsletter&email=" + email + "&name="+name + "&r=" + Math.random(),
		type: "POST",
		async: true,
		cache: false,
		success: function(data, status, xhr) {

			if(data == '10000') {
				 alert("Email inválido"); 
			}

			if(data == '10001') {
				 alert("Seu email foi cadastrado com sucesso!"); 	
				$('#iluria-popup-container').fadeOut();
			}

			if(data == '10002') {
				 alert("Esse email já está cadastrado."); 
			}
		}
	});
}

Iluria.clientAccount.saveClientInfoForm = function() {
	var form = $("#iluria-my-account-popup-form");
	var data = form.serialize();
	Iluria.showViewProgress(Iluria.clientAccount.width, Iluria.clientAccount.height);
	Iluria.loadView("/clientServices.do?command=saveClientInfoForm" + "&r=" + Math.random(), data, 
		function(response, responseStatus) {
			if(response == '31001')
			{
				 alert("O email informado já está cadastrado."); 
				
				
				
				
				
			}
			else
			{
				 alert("Dados atualizados com sucesso."); 
				
				
				
				
				
			}
			Iluria.clientAccount.showClientInfoForm();
	}, "POST");
}

Iluria.clientAccount.saveClientAddressForm = function() {
	var form = $("#iluria-my-account-popup-form");
	var data = form.serialize();
	Iluria.showViewProgress(Iluria.clientAccount.width, Iluria.clientAccount.height);
	Iluria.loadView("/clientServices.do?command=saveClientAddressForm" + "&r=" + Math.random(), data, 
		function(response) {
			 alert("Dados atualizados com sucesso."); 
			
			
			
			
			
			Iluria.clientAccount.showClientAddressForm();
	}, "POST");
}

Iluria.clientAccount.submitMercadoPago = function() {
	var form = $("#iluria-payment-form-mercado-pago");
	var data = form.serialize();
	Iluria.showViewProgress(Iluria.clientAccount.width, Iluria.clientAccount.height);
	Iluria.loadView("/clientServices.do?command=submitMercadoPagoPayment" + "&r=" + Math.random(), data, 
		function(response, status) {
			if(status == 10016)
			{
				alert("Não foi possível pagar usando o Mercado Pago.");
				Iluria.clientAccount.showClientOrderHistoryForm();
			}
			else if(status == 200)
			{
				document.location = response;
			}
			else
			{
				Iluria.clientAccount.showClientOrderHistoryForm();
			}
			
	}, "POST");
}

Iluria.clientAccount.showClientAddressForm = function () {
	Iluria.showViewProgress(Iluria.cart.width, Iluria.cart.height);
	Iluria.loadView("/clientServices.do?command=showClientAddressForm" + "&r=" + Math.random(), 
		function(response) {
			Iluria.showView(response);			
	});
}

Iluria.clientAccount.saveClientPasswordForm = function() {
	var form = $("#clientDataForm");
	var data = form.serialize();
	Iluria.showViewProgress(Iluria.clientAccount.width, Iluria.clientAccount.height);
	Iluria.loadView("/clientServices.do?command=saveClientPasswordForm" + "&r=" + Math.random(), data, 
		function(response, responseStatus) {
			if(response == 32001) {
				 alert("A senha atual está incorreta."); 
				
				
				
				
				
			}
			else 
				 alert("Senha atualizada com sucesso."); 
				
				
				
				
				
			Iluria.clientAccount.showClientPasswordForm();
	}, "POST");
}
 
Iluria.clientAccount.saveClientTestimonialForm = function() {
	var form = $("#clientDataForm");
	var data = form.serialize();
	Iluria.showViewProgress(Iluria.clientAccount.width, Iluria.clientAccount.height);
	Iluria.loadView("/clientServices.do?command=saveClientTestimonialForm"+ "&r=" + Math.random(), data, 
		function(response, responseStatus) {
			if(response == 32003) {
				alert("O depoimento não pode estar em branco.");
			}
			else if(response == 32004) {
				alert("O apelido não pode estar em branco.");
			}
			else 
				 alert("Recebemos seu depoimento com sucesso e após a aprovação ele será publicado em nossa loja.\n\nObrigado!"); 
				
				
				
				
				
			
			Iluria.clientAccount.showClientTestimonialForm();
	}, "POST");
}

Iluria.clientAccount.showClientPasswordForm = function () {
	Iluria.showViewProgress(Iluria.cart.width, Iluria.cart.height);
	Iluria.loadView("/clientServices.do?command=showClientPasswordForm" + "&r=" + Math.random(), 
		function(response) {
			Iluria.showView(response);			
	});
}

Iluria.clientAccount.showClientTestimonialForm = function () {
	Iluria.showViewProgress(Iluria.cart.width, Iluria.cart.height);
	Iluria.loadView("/clientServices.do?command=showClientTestimonialForm" + "&r=" + Math.random(), 
		function(response) {
			Iluria.showView(response);			
	});
}

Iluria.clientAccount.showClientOrderHistoryForm = function () {
	Iluria.showViewProgress(Iluria.cart.width, Iluria.cart.height);
	Iluria.loadView("/clientServices.do?command=showClientOrderHistoryForm" + "&r=" + Math.random(), 
		function(response) {
			Iluria.showView(response);			
	});
}

Iluria.clientAccount.showClientOrderDetailsForm = function (orderId) {
	Iluria.showViewProgress(Iluria.cart.width, Iluria.cart.height);
	Iluria.loadView("/clientServices.do?command=showClientOrderDetailsForm&webCode=" + orderId + "&r=" + Math.random(), 
		function(response) {
			Iluria.showView(response);
	});
}

Iluria.clientAccount.saveClientOrderMessage = function(orderId) {
	var form = $("#clientDataForm");
	var data = form.serialize();
	Iluria.showViewProgress(Iluria.clientAccount.width, Iluria.clientAccount.height);
	Iluria.loadView("/clientServices.do?command=saveClientOrderMessage", data, 
		function(response, responseStatus) {
			Iluria.loadView("/clientServices.do?command=showClientOrderDetailsForm&webCode=" 
				+ orderId + "&tabId=2", 
			function(response) {
				Iluria.showView(response);
		});
	}, "POST");
}

Iluria.clientAccount.saveShippingManualForm = function(orderId) {
	var form = $("#shippingManualForm");
	
	
	
	var data = form.serialize();
	Iluria.showViewProgress(Iluria.clientAccount.width, Iluria.clientAccount.height);
	Iluria.loadView("/clientServices.do?command=readManualShippingOption"+ "&r=" + Math.random(), data, 
		function(response, responseStatus) {
			Iluria.loadView("/clientServices.do?command=showClientOrderDetailsForm&webCode=" 
				+ orderId + "&tabId=0", 
			function(response) {
				Iluria.showView(response);
		});
	}, "POST");
	
	
}

Iluria.showView = function(html) {
	$("#iluria-view-container").html(html);
}

Iluria.loadView = function(url, data, callback, method) {
	if(typeof(data) == "function") {
		callback = data;
		data = "";
	}
	if(method == null) method = "GET";
	$.ajax({
		url: url,
		data: data,
		type: method,
		async: true,
		cache: false,
		contentType : "application/x-www-form-urlencoded; charset=utf-8",
		success: function(responseData, status, xhr) {
			callback.call(this, responseData, xhr.status);
		},
		error: function(xhr, status, error) {
			callback.call(this, null, xhr.status);
		}
	});
}

Iluria.showViewProgress = function(width, height) {
	$("#iluria-view-container").html("<div style='width: " 
		+ width + "px; height: " + height 
		+ "px; overflow: auto'><table cellpadding=0 cellspacing=0 width='" 
		+ width + "' height='" 
		+ height + "'><tr><td valign='center' align='center'><img src=\
		'/webCommons/img/spinner2.gif'></td></tr></table></div>");
}

Iluria.initView = function(width, height, callback) {
	var view = $("#iluria-view");

	if(view.size() == 0)
		$("body").append("<div id='iluria-view' style='display: none'/>");

	$("#iluria-view").html("<div style='overflow: auto; width:" + (width+20) + "px; height: " + height + "px;'><div id='iluria-view-container' style='width: " 
							+ width + "px; height: " + height 
							+ "px; overflow: auto'><table cellpadding=0 cellspacing=0 width='" 
							+ width + "' height='" 
							+ height + "'><tr><td valign='center' align='center'><img src=\
							'/webCommons/img/spinner2.gif'></td></tr></table></div></div>");
							
	$("#iluria-view").prettyPhoto({
		theme: 'facebook', 
		hideflash: 'true',
		allowresize: false,
		showTitle: false,
		default_width: width+20,
		default_height: height,
		changepicturecallback: function() {
			$("#iluria-view").html("");
			callback.call(this);
		}
	});
	$.prettyPhoto.open('#iluria-view');
}



Iluria.trim = function(str) {
	if(typeof(str) == "undefined") str = "";
	return str.replace(/^\s+|\s+$/g,"");
}

Iluria.showContactForm = function () {
	

	Iluria.initView(Iluria.clientAccount.width, Iluria.clientAccount.height, function() {
		Iluria.loadView("/clientServices.do?command=showContactForm", 
			function(response) {
				Iluria.showView(response);			
		});
	});
}

Iluria.saveContactForm = function() {
	var form = $("#clientDataForm");
	var data = form.serialize();
	Iluria.showViewProgress(Iluria.clientAccount.width, Iluria.clientAccount.height);
	Iluria.loadView("/clientServices.do?command=saveContactForm", data, 
		function(response, responseStatus) {
			$.prettyPhoto.close();
			if(response == 32005) {
				 alert("A mensagem não pode estar em branco."); 
				
				
				
				
				
			}
			else if(response == 32006) {
				 alert("O email não pode estar em branco."); 
				
				
				
				
				
			}
			else {
				 alert("Recebemos sua mensagem com sucesso e em breve ela será respondida."); 
				
				
				
				
				
			}
	}, "POST");
}

Iluria.showLoginForm = function() {
	
	
	document.location = "/login.html";
	
}

Iluria.showLoginSSLForm = function() {
	
	
	document.location = "/login-ssl.html";
	
}

Iluria.showMessageForm = function() {
	
	
	document.location = "/contact.html";
}


Iluria.inlineCart = function() {}

Iluria.inlineCart.showCart = function() {
	
	
	document.location = "/cart-content.html";
	
}

Iluria.inlineCart.removeFromCart = function(productId, variationId) {
	document.cartForm.command.value = "removeFromCart";
	document.cartForm.productId.value = productId;
	document.cartForm.variationId.value = variationId;
	document.cartForm.submit();
}

Iluria.inlineCart.addToCart = function() {
	if (typeof productHasPriceOnApplicationFunction === "function") {
		productHasPriceOnApplicationFunction(productId);
		return;
	}
	
	

	

	var variationId1 = $("#iluria-product-variation1").val();
	var variationId2 = $("#iluria-product-variation2").val();
	var variationId3 = $("#iluria-product-variation3").val();
	
	if(variationId1=="0" || variationId2=="0" || variationId3=="0"){
		alert("Selecione a varia\u00E7\u00E3o do produto.");
		return;
	}
	
	$("#productVariationId1").val(variationId1);
	$("#productVariationId2").val(variationId2);
	$("#productVariationId3").val(variationId3);
	
	/** addToCartForm está implementado nos templates **/
	document.addToCartForm.submit();
}

Iluria.inlineCart.updateQuantity = function(productId, quantity, variationId) {
	document.cartForm.command.value = "updateQuantity";
	document.cartForm.productId.value = productId;
	document.cartForm.variationId.value = variationId;
	document.cartForm.quantity.value = quantity;
	document.cartForm.submit();
}

Iluria.inlineCart.saveCartComments = function(commentsFormId) {
	var comments = document.getElementById(commentsFormId).value;
	
	document.cartForm.command.value = "updateComments";
	document.cartForm.comments.value = comments;
	document.cartForm.submit();
}

Iluria.inlineCart.saveCartCoupon= function(couponFieldId) {
	var coupon = document.getElementById(couponFieldId).value;
	
	document.cartForm.command.value = "updateCoupon";
	document.cartForm.couponId.value = coupon;
	document.cartForm.submit();
}

Iluria.inlineCart.selectShippingType = function (shippingType) {
	document.cartForm.command.value = "updateShippingType";
	document.cartForm.shippingType.value = shippingType;
	document.cartForm.submit();
}

Iluria.inlineCart.calculateShipping = function (zip) {
	document.cartForm.command.value = "calculateShipping";
	document.cartForm.zip.value = zip;
	document.cartForm.submit();
}

Iluria.inlineCart.saveDepositDiscountOption= function(commentsFormId) {
	document.depositDiscountForm.submit();
}

Iluria.inlineCart.showClientAddressForm = function () {
	document.location = "/cart-client-address.html";
}

Iluria.inlineCart.backFromClientAddress = function() {
	document.clientDataForm.command.value = "saveClientAddress";
	document.clientDataForm.redirectUrl.value = "/cart-content.html";
	document.clientDataForm.submit();
}

Iluria.inlineCart.nextFromClientAddress = function() {
	document.clientDataForm.command.value = "saveClientAddress";
	document.clientDataForm.redirectUrl.value = "/cart-client-info.html";
	document.clientDataForm.submit();
}

Iluria.inlineCart.backFromClientInfoToClientAddress = function() {
	document.clientDataForm.command.value = "saveClientInfo";
	document.clientDataForm.redirectUrl.value = "/cart-client-address.html";
	document.clientDataForm.submit();
}

Iluria.inlineCart.nextFromClientInfoToPayment = function() {
	document.clientDataForm.command.value = "saveClientInfo";
	document.clientDataForm.redirectUrl.value = "/cart-payment-info.html";
	document.clientDataForm.submit();
}

Iluria.inlineCart.backFromPaymentInfo = function() {
	document.clientDataForm.command.value = "savePaymentInfo";
	document.clientDataForm.redirectUrl.value = "/cart-client-info.html";
	document.clientDataForm.submit();
}

Iluria.inlineCart.submitOrder = function() {
	document.clientDataForm.command.value = "savePaymentInfo";
	document.clientDataForm.redirectUrl.value = "/cart-submit-order.html";
	document.clientDataForm.submit();
}

Iluria.inlineCart.submitOrderFinal = function() {
	document.clientDataForm.command.value = "saveClientInfoFinal";
	document.clientDataForm.redirectUrl.value = "/cart-order-done.html";
	document.clientDataForm.submit();
}

Iluria.inlineCart.loadAddress = function() {
	document.clientDataForm.command.value = "loadAddress";
	document.clientDataForm.redirectUrl.value = "/cart-client-address.html";
	document.clientDataForm.submit();
}

Iluria.inlineCart.backFromClientFinal = function() {
	document.clientDataForm.command.value = "saveClientInfoFinal";
	document.clientDataForm.originPage.value = "backFromClientFinal";
	document.clientDataForm.redirectUrl.value = "/cart-content.html";
	document.clientDataForm.submit();
}

Iluria.inlineLogin = function() {}

Iluria.inlineLogin.doLogin = function(){

	
	
	if($("input[name=username]").val() == "")
        {
            alert("Por favor informe seu email.");
            return;
        }
        if($("input[name=password]").val() == "")
        {
            alert("Por favor informe sua senha.");
            return;
        }
	document.loginForm.submit();
}

Iluria.inlineLogin.signup = function(){
	

	if(trim($("#signupForm input[name=fullname]").val()) == "") {
            alert("Por favor informe seu nome completo.");
            return;
        }
        
        if(trim($("#signupForm input[name=email]").val()) == "") {
            alert("Por favor informe seu email.");
            return;
        }
        
        if(trim($("#signupForm input[name=password]").val()) == "") {
            alert("Por favor informe sua senha.");
            return;
        }
        
        if(trim($("#signupForm input[name=password]").val()) != trim($("input[name=passwordConfirm]").val())) {
            alert("As senhas digitadas não são iguais.");
            return;
        }

        document.signupForm.submit();
}

Iluria.inlineLogin.recoverPassword = function(){
	

		if($("input[name=username]").val() == "")
        {
            alert("Por favor informe seu email.");
            return;
        }
        var msg = "Reenviaremos sua senha para o email informado. Confirma?";
        
        if(window.confirm(msg))
        {
            document.loginForm.command.value = "recoverPassword";
            document.loginForm.redirectUrl.value = "login.html";
            document.loginForm.submit();
        }
}

Iluria.inlineLogin.recoverPasswordSSL = function(){
	

		if($("input[name=username]").val() == "")
        {
            alert("Por favor informe seu email.");
            return;
        }
        var msg = "Reenviaremos sua senha para o email informado. Confirma?";
        
        if(window.confirm(msg))
        {
            document.loginForm.command.value = "recoverPassword";
            document.loginForm.redirectUrl.value = "login-ssl.html";
            document.loginForm.submit();
        }
}

function isWindowsFont(fontName) { 
	if(fontName == "Arial" || fontName == "Tahoma"
		|| fontName == "Trebuchet MS" || fontName == "Verdana")
		return true;
	
	return false;
}

// Carregar uma fonte do google selecionada
var loadedFonts = {};

function loadFont(font)
{
	if(!loadedFonts[font])
	{
		loadedFonts[font] = true;
		if(!isWindowsFont(font))
			$("head").append('<link href="https://fonts.googleapis.com/css?family='+font+'" rel="stylesheet" type="text/css">');
	}
}


(function ($) {
	$.fn.menuVertical = function () {
		return this.each(function () {
			var menu = this;
			if($(this).find("ul").length){
				$(this).find(".category-title-arrow a").text("2"); 
				$(this).children("span").attr("menuStatus", "left"); 
				$(this).children("span").click(function() {
					
	
					if($(this).attr("menuStatus") != "down") { // Esconder o menu selecionado anteriormente
						var selectedCategory = $(menu).parent("ul").find("li").find("span[menuStatus='down']");
						$(selectedCategory).next("ul").slideToggle(200);
						$(selectedCategory).find(".category-title-arrow a").text("2"); 					
						$(selectedCategory).attr("menuStatus", "left");
					}
				
					if($(this).next("ul").css("display") == "none") { 
						$(this).find(".category-title-arrow a").text("4"); 
						$(this).attr("menuStatus", "down");
					} else {
						$(this).find(".category-title-arrow a").text("2"); 
						$(this).attr("menuStatus", "left");
					}
					
					$(this).next("ul").slideToggle(200);
				});
			}
		});
	}
})(jQuery);
