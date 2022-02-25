import { Injectable} from '@angular/core';
import { CanActivate,  Router} from '@angular/router';

@Injectable()
export class CanActivateService implements CanActivate {

    constructor(private router: Router) {

    }

    canActivate(): boolean {
            if (localStorage.getItem('access_token')) {
             let countryCode = localStorage.getItem('countryCode') ? localStorage.getItem('countryCode') : 'arm';
             let shortCode = localStorage.getItem('shortCode') ? localStorage.getItem('shortCode') : 'hy';
                this.router.navigateByUrl(`/${countryCode}/${shortCode}/dashboard`);
                return false;
            }
        return true;
    }
}
