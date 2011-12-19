// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
var $jq=jQuery.noConflict()

$jq(function(){
    jQuery('#tabs').tabs();
});

Ajax.Responders.register({
    onCreate: function(request) {
        var csrf_meta_tag = $$('meta[name=csrf-token]')[0];
        if (csrf_meta_tag) {
            var header = 'X-CSRF-Token',
            token = csrf_meta_tag.readAttribute('content');
            if (!request.options.requestHeaders) {
                request.options.requestHeaders = {};
            }
            request.options.requestHeaders[header] = token;
        }
    }
});

// /event/_result rating
$jq(function(){
    $jq('.star').raty( {
        start: function() {
            var targetID = this.id;
            var avg = $jq('#'+targetID).attr('avg')
            return parseFloat(avg);
        },
        half:  true,
        halfShow: true,
        //  cancel: true,
        click: function(score,evt) {
            if ($jq('#'+this.id).attr('user')=='true'){
                jQuery.ajax( "/ratings/rate/"+ this.id +"?score="+score)
            }else {
                alert('Please login to rate an event.')
                // window.location='/login'
            }
        }
    }
)
}
);

// /event/show rating
$jq(function(){
    $jq('#star').raty( {
        start:function() {
            var targetID = this.id;
            var avg = $jq('#'+targetID).attr('avg')
            return parseFloat(avg);  },
        noRatedMsg: 'Please rate this event!',
        half:  true,
        halfShow: true,
        cancel: true,
        click: function(score,evt) {
            if ($jq('#'+this.id).attr('user')=='true'){
                jQuery.ajax( "/ratings/rate/"+ this.id +"?score="+score)
            }else {
                alert('Please login to rate an event.')
                // window.location='/login'
            }
        },
        cancelHint:   'You sure you want to cancel?',
        target:       '#hint',
        targetFormat: 'Your rating: {score}',
        targetText:   'You haven\'t rated yet!',
        targetKeep:    true,
        hintList:       ['Who cares', 'Weak', 'Fun', 'Rad', 'Sick!']
    }
)
 
}
);

