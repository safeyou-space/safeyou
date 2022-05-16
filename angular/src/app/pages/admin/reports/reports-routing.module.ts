import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import {ReportsComponent} from "./reports.component";

const routes: Routes = [
  {
    path: '',
    component: ReportsComponent,
    data: {
      title: 'Reports'
    }
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class ReportsRoutingModule { }
