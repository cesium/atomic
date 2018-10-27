function setupInitialValues() {
    var searchParams = new URLSearchParams(window.location.search);

    $("#position").val(searchParams.get("filter_position"));
    $("#company").val(searchParams.get("filter_company"));
    $("#city").val(searchParams.get("filter_location"));
    $("#dateFrom").val(searchParams.get("filter_start_date"));
    $("#dateTo").val(searchParams.get("filter_end_date"));
}

function addDates(params) {
    var dateFrom = $("#dateFrom").val();
    var dateTo = $("#dateTo").val();

    params["filter_end_date"] = new Date().toLocaleDateString();
    params["filter_start_date"] = "2018-01-01";

    if (dateFrom) {
        params["filter_start_date"] = dateFrom;
    }

    if (dateTo) {
        params["filter_end_date"] = dateTo;
    }
}

function getParams() {
    var params = {};

    var position = $("#position").val();
    if (position) { params["filter_position"] = position; }

    var company = $("#company").val();
    if (company) { params["filter_company"] = company; }

    var city = $("#city").val();
    if (city) { params["filter_location"] = city; }

    addDates(params);

    return params;
}

function redirectTo() {
    var url = window.location.origin + window.location.pathname;
    var params = jQuery.param(getParams());

    window.location.replace(url + "?" + params);
}

function setupFilter() {
    $("#filter").on("show.bs.modal", function () {
        var $window = $(this).find(".modal-content");

        $window.find(".btn-filter").click(function () {
            redirectTo();
        });

        $window.find(".btn-reset").click(function () {
            window.location.replace(window.location.origin + window.location.pathname);
        });
    });
}

$(document).ready(function() {
    $("#dateFrom").datepicker({ dateFormat: "yy-mm-dd" });
    $("#dateTo").datepicker({ dateFormat: "yy-mm-dd" });

    setupInitialValues();
    setupFilter();
});
