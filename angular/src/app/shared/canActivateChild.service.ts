import { Injectable} from '@angular/core';
import { CanActivateChild, Router} from '@angular/router';

@Injectable()
export class CanActivateChildService implements CanActivateChild {

    constructor(private router: Router) {

    }

    canActivateChild(): boolean {
            if (localStorage.getItem('access_token')) {
                return true;
            }
        this.router.navigateByUrl('login');
        return false;
    }
}
