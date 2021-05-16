import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import {EmergencyServiceCategoryComponent} from "./emergency-service-category.component";

const routes: Routes = [
  {
    path: '',
    component: EmergencyServiceCategoryComponent,
    data: {
      title: 'Network categories'
    }
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class EmergencyServiceCategoryRoutingModule { }
