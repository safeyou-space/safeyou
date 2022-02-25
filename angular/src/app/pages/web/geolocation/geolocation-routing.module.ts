import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import {GeolocationComponent} from "./geolocation.component";

const routes: Routes = [
  {
    path: '',
    component: GeolocationComponent,
    data: {
      title: 'Geolocation'
    }
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class GeolocationRoutingModule { }
