import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import {SafeYouViewComponent} from "./safe-you-view.component";

const routes: Routes = [
  {
    path: '',
    component: SafeYouViewComponent,
    data: {
      title: 'Safe you'
    }
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class SafeYouViewRoutingModule { }
