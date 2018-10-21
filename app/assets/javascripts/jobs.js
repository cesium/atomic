function setupInitialValues() {
    $.urlParam = function(name){
        var results = new RegExp('[\?&]' + name + '=([^&#]*)').exec(window.location.href);
        if (results==null){
           return null;
        }
        else{
           return decodeURI(results[1]) || 0;
        }
    }

    $('#position').val($.urlParam('filter_position'));
    $('#company').val($.urlParam('filter_company'));
    $('#city').val($.urlParam('filter_location'));
    $('#dateFrom').val($.urlParam('filter_start_date'));
    $('#dateTo').val($.urlParam('filter_end_date'));
}

function getParams() {
    var params = {};

    var position = $('#position').val();
    if (position) params['filter_position'] = position;

    var company = $('#company').val();
    if (company) params['filter_company'] = company;

    var city = $('#city').val();
    if (city) params['filter_location'] = city;

    var dateFrom = $('#dateFrom').val();
    if (dateFrom) params['filter_start_date'] = dateFrom;

    var dateTo = $('#dateTo').val();
    if (dateTo) params['filter_end_date'] = dateTo;

    return params;
}

function redirectTo() {
    var url = window.location.origin + window.location.pathname;
    var params = jQuery.param(getParams());

    window.location.replace(url + "?" + params);
}

function setupFilter() {
    $('#filter').on('show.bs.modal', function () {
        $window = $(this).find('.modal-content');

        $window.find('.btn-filter').click(function () {
            redirectTo();
        });

        $window.find('.btn-reset').click(function () {
            window.location.replace(window.location.origin + window.location.pathname);
        });
    });
}

$(document).ready(function() {
    $('#dateFrom').datepicker({ dateFormat: 'yy-mm-dd' });
    $('#dateTo').datepicker({ dateFormat: 'yy-mm-dd' });

    setupInitialValues();
    setupFilter();
});
