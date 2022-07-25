import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import {TermsOfConsultationComponent} from "./terms-of-consultation.component";

const routes: Routes = [
  {
    path: '',
    component: TermsOfConsultationComponent,
    data: {
      title: 'Terms of Consultation'
    }
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class TermsOfConsultationRoutingModule { }
