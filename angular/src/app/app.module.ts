import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppComponent } from './app.component';
import {BrowserAnimationsModule} from "@angular/platform-browser/animations";
import {TooltipModule} from "ngx-bootstrap/tooltip";
import {AppRoutingModule} from "./app.routing";
import {SharedModule} from "./components/shared.module";
import { NotFoundComponent } from './pages/admin/not-found/not-found.component';
import {DefaultLayoutComponent} from "./components/default-layout/default-layout.component";
import {HTTP_INTERCEPTORS, HttpClientModule} from "@angular/common/http";
import {RefreshTokenService} from "./shared/refresh-token.service";
import {ToastrModule} from "ngx-toastr";
import {AppInterceptor} from "./shared/app-interceptor";

@NgModule({
  declarations: [
    AppComponent,
    NotFoundComponent,
    DefaultLayoutComponent,
  ],
  imports: [
    BrowserModule,
    BrowserAnimationsModule,
    TooltipModule.forRoot(),
    AppRoutingModule,
    SharedModule,
    HttpClientModule,
    ToastrModule.forRoot()
  ],
  providers: [{provide: HTTP_INTERCEPTORS, useClass: AppInterceptor, multi: true},{ provide: HTTP_INTERCEPTORS, useClass: RefreshTokenService, multi: true }],
  bootstrap: [AppComponent]
})
export class AppModule { }
