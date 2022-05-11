import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import {BeneficiaryComponent} from "./beneficiary.component";

const routes: Routes = [
  {
    path: '',
    component: BeneficiaryComponent,
    data: {
      title: 'Beneficiary'
    }
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class BeneficiaryRoutingModule { }
