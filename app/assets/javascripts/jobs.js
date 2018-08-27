function hasCity(jobOfferCity, city) {
    if (city != '') {
        if (!jobOfferCity) {
            return false
        } else {
            return jobOfferCity.includes(city);
        }
    }

    return true;
}

function hasTags(jobOfferTags, tags) {
    for (let index = 0; index < tags.length; index++) {
        if (!jobOfferTags.includes(tags[index])) {
            return false;
        }
    }

    return true;
}

function filterOffers($modal, $modal) {
    tags     = $modal.find('#tags')    .val().replace(/\s/g, '').toLowerCase().split(',');
    position = $modal.find('#position').val().toLowerCase();
    company  = $modal.find('#company') .val().toLowerCase();
    city     = $modal.find('#city')    .val().toLowerCase();
    dateFrom = $modal.find('#dateFrom').val();
    dateTo   = $modal.find('#dateTo')  .val();

    $('.jobs-container').find('.job-container').each(function () {
        jobOfferTags     = $(this).find('.tags') .text().replace(/\s/g, '').toLowerCase().split(',');
        jobOfferPosition = $(this).find('.post-title').text().toLowerCase();
        jobOfferCompany  = $(this).find('.company')   .text().toLowerCase();
        jobOfferDate     = $(this).find('.date')      .text();
        cityText         = $(this).find('.city');

        if (cityText.length) {
            var jobOfferCity = cityText.text().toLowerCase();
        }

        if (
            jobOfferPosition.includes(position) &&
            jobOfferDate >= dateFrom            &&
            jobOfferDate <= dateTo              &&
            jobOfferCompany.includes(company)   &&
            hasCity(jobOfferCity, city)         &&
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
    $('#dateTo').datepicker({ dateFormat: 'yy-mm-dd' });

    $('#job_all_tags').tokenfield();

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