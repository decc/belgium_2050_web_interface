shareHTML = """
 <div id='share'>
    <div id='url'>
      <h1>Sharing this pathway with others</h1>
      <p>
        If you want to save or share your pathway, bookmark this page, or take note of its url*:
        <a id='pathwayurl'></a>
      </p>
      <p>
        To share, just send someone the url, or click this share button:
        <!-- AddThis Button BEGIN -->
        <a class="addthis_button" href="http://www.addthis.com/bookmark.php?v=250&amp;username=tomcounsell"><img src="http://s7.addthis.com/static/btn/v2/lg-share-en.gif" width="125" height="16" alt="Bookmark and Share" style="border:0"/></a>
        <script type="text/javascript">var addthis_config = {"data_track_clickback":true};</script>
        <script type="text/javascript" src="http://s7.addthis.com/js/250/addthis_widget.js#username=tomcounsell"></script>
        <!-- AddThis Button END -->
      </p>
      <p>* On modern browsers, this url is the same as the one you will see in the address bar as you use the calculator. On older browsers, such as Internet Explorer 6 and 7, it will not be.</p>
    </div>
  </div>
"""

class Share

  constructor: () ->
    @ready = false
  
  setup: () ->
    return false if @ready
    @ready = true
    $('#results').append(shareHTML)

  teardown: () ->
    $('#results').empty()
    @ready = false
  
  updateResults: (@pathway) ->
    @setup() unless @ready
    url = "http://#{window.location.host}#{twentyfifty.url({action:'primary_energy_chart'})}"
    #$('#share input')[0].value = url
    $('#share a#pathwayurl').text(url)
    $('#share a#pathwayurl').attr({href:url})
    $('#excel textarea').val(twentyfifty.getChoices().join("\n"))


loadFromExcel = () ->
  pasted_choices = $('#excel textarea').val().split(/\r\n|\r|\n/)
  pasted_choices = for c in pasted_choices
    if c == ""
      "0"
    else
      c
  twentyfifty.setChoices(pasted_choices)
  twentyfifty.switchView('primary_energy_chart')
  return false

window.twentyfifty.loadFromExcel = loadFromExcel
window.twentyfifty.views['share'] = new Share
