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
  name = () -> return localStorage.getItem("playername")
  id = () -> return localStorage.getItem("playerid")
  if name is null or id is null
    name = "SOMEHOW YOU AREN'T LOGGED IN WHAT THE FUCK"
    $location.path "/login"

  login = (pname, pid) ->
    localStorage.setItem "playername", pname
    localStorage.setItem "playerid", pid
    console.log("Logged in as #{pname}:#{pid}")
    $location.path "/"

  logout = () ->
    localStorage.removeItem "playername"
    localStorage.removeItem "playerid"
    $location.path("/login")

  return {name: name, id: id, logout: logout, login: login}

