import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import {TermsAndConditionsComponent} from "./terms-and-conditions.component";

const routes: Routes = [
  {
    path: '',
    component: TermsAndConditionsComponent,
    data: {
      title: 'Terms and Conditions'
    }
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class TermsAndConditionsRoutingModule { }
