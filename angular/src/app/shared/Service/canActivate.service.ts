import { Injectable } from '@angular/core';
import {ActivatedRoute, CanActivate, CanActivateChild, Router} from '@angular/router';

@Injectable({
  providedIn: 'root'
})
export class CanactivateService implements  CanActivateChild {

  constructor(
    private router: Router,
    public activeRoute: ActivatedRoute,
              ) { }

   // check is have a access token or not
  canActivateChild(): boolean {
    if (localStorage.getItem('access_token')) {
      return true;
    }
    this.router.navigateByUrl( 'administrator/arm/login');
    return false;
  }
}
