'use strict'

define(['angular'], (angular) ->

  users = angular.module('users', ['ngResource', 'ngRoute'])

  users.config [
    '$routeProvider',
    ($routeProvider) ->
      $routeProvider.when '/home',
        templateUrl: 'users/partials/home.tpl.html'
      $routeProvider.when '/login',
        templateUrl: 'users/partials/login.tpl.html'
      $routeProvider.when '/signup',
        templateUrl: 'users/partials/signup-start.tpl.html'
      $routeProvider.when '/signup/:token',
        templateUrl: 'users/partials/signup.tpl.html'
      $routeProvider.when '/password/reset',
        templateUrl: 'users/partials/password-reset-start.tpl.html'
      $routeProvider.when '/password/reset/:token',
        templateUrl: 'users/partials/password-reset.tpl.html'
      $routeProvider.when '/password/change',
        templateUrl: 'users/partials/password-change.tpl.html'
      $routeProvider.otherwise
        redirectTo: '/home'
  ]

  users.factory 'navigation',
    ($resource) ->
      $resource('users/navigation')

  users.controller 'SignUpCntl',
    class SignUpCntl
      constructor: ($scope, $http, $location, $routeParams) ->
        $scope.form = {} if $scope.form is undefined

        $scope.generateName = ->
          $http.get('users/generate-name')
          .success (response) ->
              $scope.form.firstName = response.firstName
              $scope.form.lastName = response.lastName

        $scope.getEmail = ->
          $http.get('users/email/' + $routeParams.token)
          .success (response) ->
              $scope.form.email = response.email
              $location.path("login") if response.email = null

        $scope.sendEmail = ->
          $http.post('users/signup', $scope.form)
          .success () ->
              $location.path("login")
          .error (response) ->
              $scope.form.errors = response

        $scope.signUp = ->
          $http.post('users/signup/' + $routeParams.token, $scope.form)
          .success () ->
              $location.path("login")
          .error (response) ->
              $scope.form.errors = response

              if (response["password"])
                $scope.form.errors["password.password2"] = response["password"]

  users.controller 'LoginCntl',
    class LoginCntl
      constructor: ($scope, $http, $location) ->
        $scope.form = {} if $scope.form is undefined

        $scope.login = ->
          $http.post('users/authenticate/userpass', $scope.form)
          .success () ->
              $location.path("home")
          .error (response) ->
              $scope.form.errors = response

        $scope.logout = () ->
          $http.get('users/logout')
          .success(() -> $location.path("/login"))
          .error(() -> $location.path("/login"))

  users.controller 'PasswordCntl',
    class PasswordCntl
      constructor: ($scope, $http, $location, $routeParams) ->
        $scope.form = {} if $scope.form is undefined

        $scope.sendEmail = ->
          $http.post('users/password/reset', $scope.form)
          .success () ->
              $location.path("login")
          .error (response) ->
              $scope.form.errors = response

        $scope.reset = ->
          $http.post('users/password/reset/' + $routeParams.token, $scope.form)
          .success () ->
              $location.path("login")
          .error (response) ->
              $scope.form.errors = response

              if (response["password"])
                $scope.form.errors["password.password2"] = response["password"]

        $scope.change = ->
          $http.post('users/password/change')
          .success () ->
              $location.path("home")
          .error (response) ->
              $scope.form.errors = response

              if (response["password"])
                $scope.form.errors["password.password2"] = response["password"]
)
