//var token = $( 'meta[name="csrf-token"]' ).attr( 'content' )
$('#tablehistory').DataTable( {
	"columnDefs": [
		{ "orderable": false, "targets": 6 }
	]
})

//var getPrice = function(price) {
	//price = price.split(' ')
	//if (price.length > 1) price = price[1].split('.')
	//else price = price[0].split('.')
	//if (price.length > 1) price = price[0]+price[1]
	//else price = price[0]
	//price = price.split(',')
	//return price[0]
//}

//var save = function(td) {
	//var itemId = td.closest('tr').attr('id')
	//var itemCode = td.closest('tr').find('td.code').text()
	//var itemName = td.closest('tr').find('td.name').text()
	//var itemPrice = td.closest('tr').find('td.price').text()
	//var itemBuyPrice = td.closest('tr').find('td.buy-price').text()
	//var itemQty = Number(td.closest('tr').find('td.qty').text())
	//var itemCategory = td.closest('tr').find('td.category').text()
	//var itemUnit = td.closest('tr').find('td.unit').text()
	//itemPrice = Number(getPrice(itemPrice))
	//itemBuyPrice = Number(getPrice(itemBuyPrice))
	//$.ajax({
		//method: "PUT",
		//url: "/items/"+itemId+".json",
		//beforeSend: function ( xhr ) {
			  //xhr.setRequestHeader( 'X-CSRF-Token', token );
		//},
		//data: {
				//item: {
					//code: itemCode,
					//name: itemName,
					//price: itemPrice,
					//buy_price: itemBuyPrice,
					//qty: itemQty,
					//unit: itemUnit,
					//category: itemCategory
				//}
			//}
	//})
	//.done(function(data) {
		//console.log("Success")
		//console.log(data)
	//})
	//.fail(function(data) {
		//console.log("Failed")
		//console.log(data)
	//})
//}

//var blurTd = function() {
	//$('td[contenteditable]').keydown(function(e) {
		//keycode = e.keyCode || e.charCode
		//if (keycode == 13) {
			//$(this).blur()
			//save($(this))
		//}
		//if (keycode == 27) $(this).blur()
	//})
//}

//var delItem = function() {
	//$('a.delete').on('click', function() {
		//var itemId = $(this).closest('tr').attr('id')
		//var tbRow = $(this).closest('tr')
		//var itemName = $(this).closest('tr').find('td.name').text()
		//if (confirm("Hapus "+itemName+"?"))
			//$.ajax({
				//method: "DELETE",
				//url: "/items/"+itemId+".json",
				//beforeSend: function ( xhr ) {
					  //xhr.setRequestHeader( 'X-CSRF-Token', token );
				//}
			//})
			//.done(function(data) {
				//tbRow.remove()
				//console.log(data)
			//})
			//.fail(function(data) {
				//console.log('Failed')
				//console.log(data)
			//})
		//else
			//console.log("Ga jadi")
		//$(this).off('click')
	//})
//}

//$('div.box-info').click(function() {
	//blurTd()
	//delItem()	
//})

//delItem()	
