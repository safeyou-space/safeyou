import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import {PoliceDataComponent} from "./police-data.component";

const routes: Routes = [
  {
    path: '',
    component: PoliceDataComponent,
    data: {
      title: 'Police Data'
    }
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class PoliceDataRoutingModule { }
