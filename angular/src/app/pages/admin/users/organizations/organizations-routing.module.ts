import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import {OrganizationsComponent} from "./organizations.component";

const routes: Routes = [
  {
    path: '',
    component: OrganizationsComponent,
    data: {
      title: 'Organizations'
    }
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class OrganizationsRoutingModule { }
