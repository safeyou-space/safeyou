import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import {CountryListComponent} from "./country-list.component";

const routes: Routes = [
  {
    path: '',
    component: CountryListComponent,
    data: {
      title: 'Choose Country'
    }
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class CountryListRoutingModule { }
