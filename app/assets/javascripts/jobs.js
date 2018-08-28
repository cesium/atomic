function hasTags(jobOfferTags, tags) {
    for (let index = 0; index < tags.length; index++) {
        if (tags[index] && !jobOfferTags.includes(tags[index])) {
            return false;
        }
    }

    return true;
}

function filterOffers($modal, $modal) {
    var tags     = $modal.find('#tags')    .val().replace(/\s/g, '').toLowerCase().split(',');
    var position = $modal.find('#position').val().toLowerCase();
    var company  = $modal.find('#company') .val().toLowerCase();
    var city     = $modal.find('#city')    .val().toLowerCase();
    var dateFrom = $modal.find('#dateFrom').val();
    var dateTo   = $modal.find('#dateTo')  .val();

    $('.jobs-container').find('.job-container').each(function () {
        var jobOfferTags     = $(this).find('.tags')      .text().replace(/\s/g, '').toLowerCase().split(',');
        var jobOfferPosition = $(this).find('.post-title').text().toLowerCase();
        var jobOfferCompany  = $(this).find('.company')   .text().toLowerCase();
        var jobOfferDate     = $(this).find('.date')      .text();
        var cityText         = $(this).find('.city');
        var jobOfferCity;

        if (cityText.length) {
            jobOfferCity = cityText.text().toLowerCase();
        } else {
            jobOfferCity = "";
        }

        if (
            jobOfferDate >= dateFrom            &&
            jobOfferDate <= dateTo              &&
            jobOfferPosition.includes(position) &&
            jobOfferCompany .includes(company)  &&
            jobOfferCity    .includes(city)     &&
            hasTags(jobOfferTags, tags)
        ) {
            $(this).show();
        } else {
            $(this).hide();
        }
    });

    $modal.modal('hide');
}

$(document).ready(function() {
    $('#dateFrom').datepicker({ dateFormat: 'yy-mm-dd' });
    $('#dateTo')  .datepicker({ dateFormat: 'yy-mm-dd' });

    $('#tags').tokenfield();

    $('#filter').on('show.bs.modal', function () {
        $modal  = $(this);
        $window = $modal.find('.modal-content');

        $window.find('.btn-filter').click(function () {
            filterOffers($window.find('.modal-body'), $modal);
        });

        $window.find('.btn-reset').click(function () {
            $('.jobs-container').find('.job-container').each(function () {
                $(this).show();
            });

            $modal.modal('hide');
        });
    });
});