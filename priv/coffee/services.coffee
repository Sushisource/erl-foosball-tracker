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
