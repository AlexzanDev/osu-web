###
#    Copyright 2015-2017 ppy Pty. Ltd.
#
#    This file is part of osu!web. osu!web is distributed with the hope of
#    attracting more community contributions to the core ecosystem of osu!.
#
#    osu!web is free software: you can redistribute it and/or modify
#    it under the terms of the Affero GNU General Public License version 3
#    as published by the Free Software Foundation.
#
#    osu!web is distributed WITHOUT ANY WARRANTY; without even the implied
#    warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#    See the GNU Affero General Public License for more details.
#
#    You should have received a copy of the GNU Affero General Public License
#    along with osu!web.  If not, see <http://www.gnu.org/licenses/>.
###

{button, span} = ReactDOMFactories
bn = 'profile-cover-selection'

class ProfilePage.CoverSelection extends React.PureComponent
  render: =>
    button
      className: osu.classWithModifiers(bn, @props.modifiers)
      style:
        backgroundImage: osu.urlPresence(@props.thumbUrl)
      onClick: @onClick
      onMouseEnter: @onMouseEnter
      onMouseLeave: @onMouseLeave
      if @props.isSelected
        span className: 'profile-cover-selection__selected',
          span className: 'far fa-check-circle'


  onClick: (e) =>
    return if !@props.url?

    $.publish 'user:cover:upload:state', [true]

    $.ajax laroute.route('account.cover'),
      method: 'post'
      data:
        cover_id: @props.name
      dataType: 'json'
    .always ->
      $.publish 'user:cover:upload:state', [false]
    .done (userData) ->
      $.publish 'user:update', userData
    .error osu.emitAjaxError(e.target)


  onMouseEnter: =>
    return if !@props.url?

    $.publish 'user:cover:set', @props.url


  onMouseLeave: ->
    $.publish 'user:cover:reset'
