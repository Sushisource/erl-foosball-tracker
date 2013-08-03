services = angular.module("foosballServices", ["ngResource"])

#General purpose service for just listing and querying data
services.factory "FoosballData", ($resource) ->
  $resource "data/:model/:id?:args", {},
    query:
      method: "GET"
      params:
        model: ""
        id: ""
        args: ""
      isArray: true


#Specifically for returning information about the Game page
services.factory "GameData", ($resource) ->
  $resource "game/:id", {},
    query:
      method: "GET"
      params:
        id: ""


services.factory "Game", ($resource) ->
  $resource "game/:id", {id: '@id'}

services.factory "PlayerGame", ($resource) ->
  $resource "player_game/:id", {id: '@id'}

services.factory "Score", ($resource) ->
  $resource "score/:id", {id: '@id'}
