import { CommonModule } from '@angular/common';
import { NgModule } from '@angular/core';

import { RootModule } from '../../app/root.module';
import { FooterComponent } from './app/footer/footer.component';
import { HeaderComponent } from './app/header/header.component';
import { HomeNewsComponent } from './app/home-page/home-news/home-news.component';
import { NavbarComponent } from './app/navbar/navbar.component';

const DECLARATIONS = [
  FooterComponent,
  HeaderComponent,
  HomeNewsComponent,
  NavbarComponent,
];

@NgModule({
  imports: [
    CommonModule,
    RootModule,
    ...DECLARATIONS,
  ],
})
/**
 * This module is included in the main bundle that gets downloaded at first page load. So it should
 * contain only the themed components that have to be available immediately for the first page load,
 * and the minimal set of imports required to make them work. Anything you can cut from it will make
 * the initial page load faster, but may cause the page to flicker as components that were already
 * rendered server side need to be lazy-loaded again client side
 *
 * Themed EntryComponents should also be added here
 */
export class EagerThemeModule {
}
