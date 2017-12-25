# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#= require jquery
#= require jquery_ujs
#= require jquery-ui/widgets/autocomplete
#= require autocomplete-rails

total = 0;

addTotal = () ->
	total = 0
	$("td.subtotal").each((i, obj) -> 
		subtotal = Number($(this).text().split(" ")[1])
		console.log $(this).text().split " "
		total += subtotal;
	);

addTotal();
console.log("Total: " + total);
$("#total").html("Rp " + total);
