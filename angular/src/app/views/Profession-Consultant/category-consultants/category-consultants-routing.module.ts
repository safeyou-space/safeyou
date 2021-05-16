import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import {CategoryConsultantsComponent} from "./category-consultants.component";

const routes: Routes = [
  {
    path: '',
    component: CategoryConsultantsComponent,
    data: {
      title: 'Category Consultant'
    }
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class CategoryConsultantsRoutingModule { }
