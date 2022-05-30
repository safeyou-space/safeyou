import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import {OpenSurveysComponent} from "./open-surveys.component";

const routes: Routes = [
  {
    path: '',
    component: OpenSurveysComponent,
    data: {
      title: 'OpenSurveys'
    }
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class OpenSurveysRoutingModule { }
