/* eslint-disable dspace-angular-ts/themed-component-usages */
import { FooterComponent } from './app/footer/footer.component';
import { HeaderComponent } from './app/header/header.component';
import { HomeNewsComponent } from './app/home-page/home-news/home-news.component';
import { NavbarComponent } from './app/navbar/navbar.component';

/**
 * Themed components present on every page, bundled for the first page load.
 * HomePageComponent is loaded lazily through its themed wrapper and needs no entry here.
 */
export const COMPONENTS = [
  FooterComponent,
  HeaderComponent,
  HomeNewsComponent,
  NavbarComponent,
];
