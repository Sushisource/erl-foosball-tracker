services = angular.module("foosballServices", ["ngResource"])

#General purpose service for just listing and querying data
services.factory "FoosballData", ($resource) ->
  $resource "data/:model/:id", {},
    query:
      method: "GET"
      isArray: true

services.factory "Game", ($resource) ->
  $resource "game/:id", {id: '@id'}

services.factory "PlayerGame", ($resource) ->
  $resource "player_game/:id", {id: '@id'}

services.factory "Score", ($resource) ->
  $resource "score/:id", {id: '@id'}

services.factory "HistoricalGame", ($resource) ->
  $resource "historical_game/:id", {id: '@id'}

services.factory "LoginSvc", ($location) ->
  name = localStorage.getItem("playername")
  id = localStorage.getItem("playerid")
  if name is null or id is null
    name = "no name"
    $location.path "/login"
  return {name: name, id: id}

