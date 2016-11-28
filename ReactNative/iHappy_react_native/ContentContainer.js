/**
 * Created by Hmily on 2016/11/26.
 */

import React, {Component} from 'react';
import {
    StyleSheet,
    Text,
    View,
    Image,
    Navigator,
    TouchableOpacity,
} from 'react-native';

import {COLOR_WHITE} from './const/GlobalConst';


import Drawer from 'react-native-drawer'
import NavigationBar from './components/NavigationBar'
import Button from './components/Button';
import NewsListView from './iHappy/pages/NewsList';
import NewsListContainer from './iHappy/containers/NewsListContainer'

export default class ContentContainer extends Component {

    closeControlPanel = () => {
        this.drawer.close();
    };
    openControlPanel = () => {
        this.drawer.open();
    };

    render() {
        let {navigator} = this.props;
        return (
            <Drawer
                ref = {(ref) => this.drawer = ref}
                content = {<View style={{backgroundColor:'green'}}/>}
                openDrawerOffset = {75}
                tapToClose = {true}
            >
                <NavigationBar
                    leftView={()=>
                    <Button
                        style = {{color:COLOR_WHITE, fontSize:16}}
                        text = "菜单"
                        onPress = {()=>this.openControlPanel()}
                    />}
                    titleView={()=><Text style={{color:COLOR_WHITE, fontSize:16}}>热点新闻</Text>}
                />

                <NewsListContainer navigator = {navigator}/>

            </Drawer>
        )
    }
}


const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: 'yellow',
    },
    navContainer: {
        margin: 13,
    },
    title: {
        // marginTop:20,
        fontSize: 17
    }
});