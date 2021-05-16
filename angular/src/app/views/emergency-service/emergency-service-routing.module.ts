import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import {EmergencyServiceComponent} from "./emergency-service.component";

const routes: Routes = [
  {
    path: '',
    component: EmergencyServiceComponent,
    data: {
      title: 'Emergency service'
    }
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class EmergencyServiceRoutingModule { }
