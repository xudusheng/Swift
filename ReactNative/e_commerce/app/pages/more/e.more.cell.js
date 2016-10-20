/**
 * Created by xudosom on 2016/10/20.
 */
import React, {Component} from 'react';

import {
    StyleSheet,
    View,
    Image,
    Text,
    Switch,
} from 'react-native';


export default class NormalCell extends Component {

    static defaultProps = {
        title: '',
        subTitle: '',
        height: 44,
        showSwitch: false,
        onValueChange: ()=> {
        },

    };

    static propTypes = {
        title: React.PropTypes.string.isRequired,
        subTitle: React.PropTypes.string,
        height: React.PropTypes.number,
        showSwitch: React.PropTypes.bool,
        onValueChange: React.PropTypes.func,
    };

    constructor(props) {
        super(props);
        this.state = {
            isOn: false,
        };
    }

    render() {
        return (
            <View style={[styles.container, {height: this.props.height}]}>
                <Text style={styles.titleStyle}>{this.props.title}</Text>
                {this.renderSwitchView()}
            </View>
        );
    }

    renderSwitchView() {
        if (this.props.showSwitch) {
            return (
                <Switch
                    style={styles.switchStyle}
                    value={this.state.isOn == true}
                    onValueChange={()=> {
                        let isSwitchOn = !this.state.isOn;
                        this.setState({
                            isOn: isSwitchOn,
                        });
                        this.props.onValueChange(isSwitchOn);
                    }}
                />
            );
        } else {
            return (
                <View style={styles.rightViewStyle}>
                    <Text style={styles.subTitleStyle}>{this.props.subTitle}</Text>
                    <Image source={{uri: 'icon_cell_rightArrow'}} style={styles.rightArrowStyle}/>
                </View>
            );
        }
    }

};

const margin = 15;
const styles = StyleSheet.create({
    container: {
        flexDirection: 'row',
        backgroundColor: 'white',
        alignItems: 'center',
        justifyContent: 'space-between',
        borderBottomColor: '#eeeeee',
        borderBottomWidth: 0.5,
    },

    titleStyle: {
        color: '#222222',
        marginLeft: margin,
    },
    subTitleStyle: {
        color: '#666666',
    },
    rightViewStyle: {
        flexDirection: 'row',
        alignItems: 'center',
    },
    switchStyle: {
        marginRight: margin,
    },
    rightArrowStyle: {
        width: 8,
        height: 13,
        marginRight: margin,
        marginLeft: 8,
    },
});