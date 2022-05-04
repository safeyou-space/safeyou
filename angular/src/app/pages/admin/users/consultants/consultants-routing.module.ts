import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import {ConsultantsComponent} from "./consultants.component";

const routes: Routes = [
  {
    path: '',
    component: ConsultantsComponent,
    data: {
      title: 'Consultants'
    }
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class ConsultantsRoutingModule { }
