import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import {ConsultantRequestsComponent} from "./consultant-requests.component";

const routes: Routes = [
  {
    path: '',
    component: ConsultantRequestsComponent,
    data: {
      title: 'Consultants Requests'
    }
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class ConsultantRequestsRoutingModule { }
